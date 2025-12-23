-- A script to download the currently playing video stream along with any captured network subtitle
-- from a source. Useful for downloading a local copy of a video when using jellyfin-mpv-shim, etc.

local msg = require("mp.msg")
local utils = require("mp.utils")

-- INFO: ----------------
--         Config
-- ----------------------
local save_directory = mp.command_native({ "expand-path", "/tmp/jellydownloader" })
local progress_file = "/tmp/mpv_jelly_progress.log"

local current_network_sub_url = nil
-- A boolean lock used to ensure only 1 download stream via FFMPEG is opened for a video at the same time
local is_downloading = false
local progress_timer = nil

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

-- HELPER: Reads the last line of the progress file to find "%"
local function update_progress_osd()
	local f = io.open(progress_file, "r")
	if not f then
		return
	end

	-- Read the last 200 bytes
	local size = f:seek("end")
	if size > 200 then
		f:seek("set", size - 200)
	else
		f:seek("set", 0)
	end
	local content = f:read("*a")
	f:close()

	-- Parsing YT-DLP format: "[download]   1.9% of    6.77GiB at   10.97MiB/s ETA 10:20"
	local percent = string.match(content, "(%d+%.?%d*)%%")
	local speed = string.match(content, "at%s+(%S+)")

	if percent then
		local msg = string.format("Download: %s%% at %s", percent, speed or "?")
		mp.osd_message(msg, 1)
	else
		mp.osd_message("Starting download...", 1)
	end
end

-- HELPER: Run command with "sh -c" to allow file redirection (>)
local function run_with_progress(cmd_string, step_name, callback)
	msg.info("Running: " .. cmd_string)

	mp.command_native_async({
		name = "subprocess",
		playback_only = false,
		-- We use 'sh -c' so we can use '>' to redirect output to a file
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

local function download_video_and_captured_sub()
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

	-- Check if file exists
	local info = utils.file_info(final_video_path)
	if info and info.size > 0 then
		mp.osd_message("File exists. Skipping download.", 3)
		prompt_open_file(final_video_path)
		return
	end

	-- START DOWNLOAD & LOCK
	is_downloading = true

	-- Clear old progress file
	os.execute("echo '' > " .. progress_file)

	-- Start the timer to poll the file
	progress_timer = mp.add_periodic_timer(0.5, update_progress_osd)

	-- Construct command: yt-dlp [args] > progress_file 2>&1
	-- We use 'sh -c' so we must wrap the inner command in quotes
	local cmd = string.format("yt-dlp -o '%s' --newline '%s' > '%s' 2>&1", final_video_path, video_url, progress_file)

	run_with_progress(cmd, "video download", function(success_video)
		-- STOP TIMER & UNLOCK
		if progress_timer then
			progress_timer:kill()
		end
		progress_timer = nil
		is_downloading = false

		if not success_video then
			return
		end

		if current_network_sub_url then
			mp.osd_message("Fetching subtitle...", 2)
			local final_sub_path = utils.join_path(final_save_dir, clean_title .. ".srt")
			local sub_cmd = string.format("curl -s -L -o '%s' '%s'", final_sub_path, current_network_sub_url)

			run_with_progress(sub_cmd, "sub download", function()
				prompt_open_file(final_video_path)
			end)
		else
			prompt_open_file(final_video_path)
		end
	end)
end

-- Listeners
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

mp.add_key_binding("alt+s", "download-video", download_video_and_captured_sub)

msg.info("Jellyfin Downloader (Async+Progress) loaded.")
