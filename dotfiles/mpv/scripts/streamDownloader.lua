-- A script to download the currently playing video stream along with any captured network subtitle
-- from a source. Useful for downloading a local copy of a video when using jellyfin-mpv-shim, etc.

local msg = require("mp.msg")
local utils = require("mp.utils")

-- INFO: ----------------
--         config
-- ----------------------

local save_directory = mp.command_native({ "expand-path", "/tmp/jellydownloader" })
local progress_file = "/tmp/mpv_jelly_progress.log"

-- Optional: A local server URL to check before attempting the primary URL.
-- Useful to save external bandwidth if you are often on the same network as the server.
-- e.g., "http://192.168.1.50:8096"
local local_server_url = "http://192.168.68.69:8096"

local current_network_sub_url = nil
-- A boolean lock used to ensure only 1 download stream via FFMPEG is opened for a video at the same time
local is_downloading = false
local progress_timer = nil

-- INFO: ----------------
--         helpers
-- ----------------------

-- Extracts series name from title
local function get_series_folder_name(title)
	local patterns = { "%s*-%s*[sS]%d+[eE]%d+", "[sS]%d+[eE]%d+", "[sS]eason %d+", "[eE]pisode %d+" }
	for _, pat in ipairs(patterns) do
		local series_name = string.match(title, "^(.-)%s*" .. pat)
		if series_name and #series_name > 0 then
			return series_name:gsub("[%s_-]+$", "")
		end
	end
	local first_digit = title:find("%d")
	if first_digit and first_digit > 1 then
		return title:sub(1, first_digit - 1):gsub("[%s_-]+$", "")
	end
	return nil
end

-- HELPER: Extracts Jellyfin server info from a stream URL
local function extract_jellyfin_info(url)
	-- Base URL: match up to /Videos/, /Items/, or /emby/
	local base_url = url:match("^(https?://.-)/Videos/")
		or url:match("^(https?://.-)/Items/")
		or url:match("^(https?://.-)/emby/")

	-- API Key: match api_key= or Token=
	local api_key = url:match("[?&]api_key=([^&]+)") or url:match("[?&]Token=([^&]+)")

	-- Item ID: match GUID after /Videos/, /Items/, /emby/videos/ or in mediaSourceId
	local item_id = url:match("/Videos/([A-Fa-f0-9]+)/")
		or url:match("/Items/([A-Fa-f0-9]+)/")
		or url:match("/emby/videos/([A-Fa-f0-9]+)/")
		or url:match("[?&]mediaSourceId=([A-Fa-f0-9]+)")

	if base_url and api_key and item_id then
		return base_url, item_id, api_key
	end
	return nil, nil, nil
end

local function update_progress_osd()
	local f = io.open(progress_file, "r")
	if not f then
		msg.warn("DEBUG: Progress file does not exist or cannot be opened: " .. progress_file)
		return
	end

	local size = f:seek("end")
	msg.info("DEBUG: Progress file size is " .. tostring(size) .. " bytes")

	if size > 1500 then
		f:seek("set", size - 1500)
	else
		f:seek("set", 0)
	end

	local content = f:read("*a")
	f:close()

	if content == nil or content == "" then
		msg.info("DEBUG: Progress file is empty.")
	else
		-- Print the last 200 characters to keep the log relatively clean
		msg.info("DEBUG: File content tail:\n" .. string.sub(content, -200))
	end

	local out_time, out_size, out_speed

	for v in string.gmatch(content, "out_time=(%d%d:%d%d:%d%d)") do
		out_time = v
	end
	for v in string.gmatch(content, "total_size=(%d+)") do
		out_size = v
	end
	for v in string.gmatch(content, "speed=(%s*%d+%.?%d*x)") do
		out_speed = v
	end

	msg.info(
		string.format(
			"DEBUG: Parsed values -> Time: %s, Size: %s, Speed: %s",
			tostring(out_time),
			tostring(out_size),
			tostring(out_speed)
		)
	)

	if out_time or out_size then
		local time_str = out_time or "N/A"
		local size_str = out_size and string.format("%.1f MB", tonumber(out_size) / 1048576) or "?"
		local speed_str = out_speed or "N/A"

		local osd_msg = string.format("Download: %s | Size: %s | Speed: %s", time_str, size_str, speed_str)
		mp.osd_message(osd_msg, 1)
	else
		mp.osd_message("Starting download...", 1)
	end
end

-- HELPER: Run command with "sh -c"
local function run_with_progress(cmd_string, step_name, callback)
	msg.info("Running: " .. cmd_string)

	mp.command_native_async({
		name = "subprocess",
		playback_only = false,
		args = { "sh", "-c", cmd_string },
		capture_stdout = true,
		capture_stderr = true,
	}, function(success, result)
		if success and result.status == 0 then
			callback(true)
		else
			msg.error("Error in " .. step_name)
			if result.stderr then
				msg.error(result.stderr)
			end
			mp.osd_message("Download Failed!", 3)
			callback(false)
		end
	end)
end

-- Prompt user: open the new file?
local function prompt_open_file(mkv_path)
	mp.osd_message("Download Complete! Open now? (y/n)", 10)
	local function cleanup()
		mp.remove_key_binding("open-yes")
		mp.remove_key_binding("open-no")
		mp.osd_message("", 0)
	end
	mp.add_forced_key_binding("y", "open-yes", function()
		cleanup()
		mp.commandv("loadfile", mkv_path, "replace")
	end)
	mp.add_forced_key_binding("n", "open-no", function()
		cleanup()
	end)
end

local function download_video_and_captured_sub(force_overwrite)
	if is_downloading then
		mp.osd_message("⚠️ Download already in progress!", 2)
		return
	end

	local video_url = mp.get_property("path")
	if not string.match(video_url, "^https?://") then
		mp.osd_message("Not a stream.", 2)
		return
	end

	local video_title = mp.get_property("media-title") or "video"
	local clean_title = video_title:gsub("[/\\?%%*:|\"<>']", "")

	local final_save_dir = save_directory
	local series_folder = get_series_folder_name(clean_title)
	if series_folder then
		final_save_dir = utils.join_path(save_directory, series_folder)
		os.execute("mkdir -p '" .. final_save_dir .. "'")
	end

	local final_video_path = utils.join_path(final_save_dir, clean_title .. ".mkv")

	-- Check if file exists, skip if not forcing an overwrite
	if not force_overwrite then
		local info = utils.file_info(final_video_path)
		if info and info.size > 0 then
			mp.osd_message("File exists. Skipping download.", 3)
			prompt_open_file(final_video_path)
			return
		end
	else
		mp.osd_message("Force downloading and overwriting...", 2)
	end

	-- Determine download URL (API vs Stream)
	local target_download_url = video_url
	local is_jellyfin_api = false
	local active_base = nil

	local j_base, j_id, j_key = extract_jellyfin_info(video_url)

	if j_base and j_id and j_key then
		active_base = j_base

		-- Check local override
		if local_server_url and local_server_url ~= "" then
			local clean_local = local_server_url:gsub("/+$", "")
			msg.info("Checking local server: " .. clean_local)
			local res = mp.command_native({
				name = "subprocess",
				capture_stdout = true,
				capture_stderr = true,
				-- Verify local server is responding using standard Public Info endpoint
				args = {
					"curl",
					"-s",
					"-f",
					"-L",
					"-m",
					"5",
					clean_local .. "/System/Info/Public",
				},
			})
			if res and res.status == 0 then
				msg.info("Local server is reachable. Using local server.")
				active_base = clean_local
			else
				local err_code = res and res.status or "unknown"
				msg.info("Local server unreachable (Exit code: " .. tostring(err_code) .. "). Defaulting to primary.")
			end
		end

		-- Jellyfin Download API Endpoint
		target_download_url = string.format("%s/Items/%s/Download?api_key=%s", active_base, j_id, j_key)
		is_jellyfin_api = true
	end

	-- START DOWNLOAD & LOCK
	is_downloading = true

	local function do_download(url_to_use, is_fallback)
		-- Clear old progress file
		os.execute("echo '' > " .. progress_file)

		-- Start the timer to poll the file
		progress_timer = mp.add_periodic_timer(0.5, update_progress_osd)

		-- FFMPEG command utilizing the native -progress file logger
		-- -v warning stops it from spamming the mpv standard error output
		local cmd = string.format(
			"ffmpeg -y -v warning -i '%s' -map 0 -c copy -progress '%s' '%s'",
			url_to_use,
			progress_file,
			final_video_path
		)

		run_with_progress(cmd, is_fallback and "fallback video download" or "video download", function(success_video)
			-- STOP TIMER & UNLOCK
			if progress_timer then
				progress_timer:kill()
			end
			progress_timer = nil
			is_downloading = false

			if not success_video then
				-- If API download fails, cleanly fallback to the raw stream URL
				if not is_fallback and is_jellyfin_api then
					is_downloading = true
					msg.warn("API download failed. Falling back to stream URL.")
					mp.osd_message("API Download Failed. Falling back to Stream URL...", 3)
					do_download(video_url, true)
				end
				return
			end

			if current_network_sub_url then
				mp.osd_message("Fetching sidecar subtitle...", 2)
				local final_sub_path = utils.join_path(final_save_dir, clean_title .. ".srt")
				local target_sub_url = current_network_sub_url

				-- If we switched to a local server, gently patch the subtitle URL base
				-- to avoid pinging the external URL for subs too.
				if j_base and active_base and active_base ~= j_base then
					local s_start, s_end = target_sub_url:find(j_base, 1, true)
					if s_start == 1 then
						target_sub_url = active_base .. target_sub_url:sub(s_end + 1)
					end
				end

				local sub_cmd = string.format("curl -s -L -o '%s' '%s'", final_sub_path, target_sub_url)

				run_with_progress(sub_cmd, "sub download", function()
					prompt_open_file(final_video_path)
				end)
			else
				prompt_open_file(final_video_path)
			end
		end)
	end

	if is_jellyfin_api then
		mp.osd_message("Starting API Download...", 2)
	end
	do_download(target_download_url, false)
end

-- INFO: -----------------------------
--         listeners and binds
-- -----------------------------------

mp.observe_property("track-list", "native", function(name, val)
	if not val then
		return
	end
	for _, track in ipairs(val) do
		if track.selected and track["external-filename"] and track["external-filename"]:match("^http") then
			current_network_sub_url = track["external-filename"]
		end
	end
end)

mp.add_key_binding("alt+s", "download-video", function()
	download_video_and_captured_sub(false)
end)
mp.add_key_binding("alt+shift+s", "download-video-force", function()
	download_video_and_captured_sub(true)
end)

msg.info("Jellyfin Downloader (Async+Progress) loaded.")
