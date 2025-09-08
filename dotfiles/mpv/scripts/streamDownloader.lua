-- =======================================================================================
-- MPV LUA SCRIPT: Unified Jellyfin Stream Downloader
-- =======================================================================================
-- DESCRIPTION:
-- 1. Auto-detects network subtitles during playback and stores their URL.
-- 2. On ALT+s, downloads the stream & subtitle into a series-specific subfolder.
-- 3. Logs subtitle file size for debugging.
-- 4. After saving, prompts user to open the new download in mpv.
--
-- DEPENDENCIES:
-- - yt-dlp, curl, mkdir (must be in PATH)
-- =======================================================================================

local msg = require("mp.msg")
local utils = require("mp.utils")

-- ### CONFIGURATION ###
local save_directory = mp.command_native({ "expand-path", "/tmp/jellydownloader" })
-- ---------------------

local current_network_sub_url = nil

-- Extracts a likely series name from a video title to use as a folder name.
local function get_series_folder_name(title)
	-- Patterns to detect the end of a series title (e.g., S01E01, Season 1, etc.)
	local patterns = {
		"%s*-%s*[sS]%d+[eE]%d+", -- matches "Title - s01e01"
		"[sS]%d+[eE]%d+",
		"[sS]eason %d+",
		"[pP]art %d+",
		"[eE]pisode %d+",
		"[eE]%d+",
	}

	-- 1. Try to match common series patterns first
	for _, pat in ipairs(patterns) do
		-- Match everything non-greedily from the start (^) until the pattern
		local series_name = string.match(title, "^(.-)%s*" .. pat)
		if series_name and #series_name > 0 then
			-- Trim trailing whitespace or separators and return
			msg.info("Detected series name via pattern '" .. pat .. "': " .. series_name)
			return series_name:gsub("[%s_-]+$", "")
		end
	end

	-- 2. Fallback: Split at the first number if no pattern matched
	local first_digit_pos = title:find("%d")
	if first_digit_pos and first_digit_pos > 1 then
		local series_name = title:sub(1, first_digit_pos - 1)
		-- Trim trailing whitespace or separators and return
		msg.info("Detected series name via fallback (first digit): " .. series_name)
		return series_name:gsub("[%s_-]+$", "")
	end

	-- 3. Last resort: If no logic applies, don't use a subfolder.
	msg.warn("Could not determine a series name for: " .. title)
	return nil
end

-- Generic subprocess runner with stderr logging
local function run_async_command(args, step_name, callback)
	msg.info("Running command for " .. step_name .. ": " .. table.concat(args, " "))
	mp.command_native_async({
		name = "subprocess",
		playback_only = false,
		args = args,
		capture_stdout = true,
		capture_stderr = true,
	}, function(success, result, err)
		if success and result.status == 0 then
			callback(true)
		else
			local error_msg = string.format("Error during '%s' step.", step_name)
			msg.error(error_msg)
			if result and result.stderr and result.stderr ~= "" then
				msg.error("--- ERROR OUTPUT ---")
				msg.error(result.stderr)
				msg.error("--------------------")
			elseif err then
				msg.error("mpv error: " .. err)
			else
				msg.error("No stderr captured.")
			end
			mp.osd_message(error_msg .. " Check log for details.", 5)
			callback(false)
		end
	end)
end

-- Watches for network subtitle tracks and stores their URL
local function watch_for_network_subtitle()
	local track_list = mp.get_property_native("track-list")
	if not track_list then
		return
	end
	local found_url = nil
	for _, track in ipairs(track_list) do
		if track.type == "sub" and track.selected and track.external and track["external-filename"] then
			local filename = track["external-filename"]
			if string.match(filename, "^https?://") then
				found_url = filename
				break
			end
		end
	end
	if found_url and found_url ~= current_network_sub_url then
		msg.info("Captured network subtitle URL: " .. found_url)
		msg.info("Network subtitle detected and ready for download.")
		current_network_sub_url = found_url
	end
end

-- Prompt user: open the new file? Yes=loadfile, No=do nothing
local function prompt_open_file(mkv_path)
	mp.osd_message("Open the new download now? (y/n)", 10)

	local function cleanup()
		mp.remove_key_binding("open-yes")
		mp.remove_key_binding("open-no")
	end

	mp.add_forced_key_binding("y", "open-yes", function()
		cleanup()
		mp.osd_message("Opening: " .. mkv_path, 2)
		mp.commandv("loadfile", mkv_path, "replace")
	end)
	mp.add_forced_key_binding("n", "open-no", function()
		cleanup()
		mp.osd_message("Staying on current playback", 2)
	end)
end

-- Main download pipeline
local function download_video_and_captured_sub()
	local video_url = mp.get_property("path")
	if not string.match(video_url, "^https?://") then
		mp.osd_message("This is a local file, not a stream.", 3)
		return
	end
	if not current_network_sub_url then
		mp.osd_message("No network subtitle URL has been captured yet.", 4)
		msg.warn("Download triggered, but no subtitle URL was stored.")
		return
	end

	mp.osd_message("Starting download...", 2)
	msg.info("Video URL: " .. video_url)
	msg.info("Subtitle URL: " .. current_network_sub_url)

	local video_title = mp.get_property("media-title") or "video"
	local clean_title = video_title:gsub("[/\\?%%*:|\"<>']", "")

	local final_save_directory = save_directory
	local series_folder = get_series_folder_name(clean_title)

	if series_folder then
		final_save_directory = utils.join_path(save_directory, series_folder)
		msg.info("Creating series directory: " .. final_save_directory)
		-- Use mkdir -p to safely create the directory if it doesn't exist
		-- ### FIX IS HERE ###
		local mkdir_result = utils.subprocess({ name = "subprocess", args = { "mkdir", "-p", final_save_directory } })
		if mkdir_result.status ~= 0 then
			msg.error("Failed to create directory: " .. final_save_directory)
			mp.osd_message("Error: Could not create series folder.", 5)
			return
		end
	end

	local final_video_path = utils.join_path(final_save_directory, clean_title .. ".mkv")
	local final_sub_path = utils.join_path(final_save_directory, clean_title .. ".srt")

	local yt_dlp_cmd = { "yt-dlp", "-o", final_video_path, video_url }
	local curl_cmd = { "curl", "-s", "-L", "-o", final_sub_path, current_network_sub_url }

	mp.osd_message("Step 1/2: Downloading video...", 5)
	run_async_command(yt_dlp_cmd, "video download", function(success1)
		if not success1 then
			return
		end

		mp.osd_message("Step 2/2: Downloading subtitle...", 5)
		run_async_command(curl_cmd, "subtitle download", function(success2)
			if not success2 then
				return
			end

			local fi = utils.file_info(final_sub_path)
			if fi and fi.size then
				msg.info(string.format("Downloaded subtitle size: %d bytes", fi.size))
			end

			mp.osd_message("Download complete!", 3)
			msg.info("Video saved to: " .. final_video_path)
			msg.info("Subtitle saved to: " .. final_sub_path)

			-- Ask user if they want to open it now
			prompt_open_file(final_video_path)
		end)
	end)
end

local function on_file_load()
	current_network_sub_url = nil
end

mp.observe_property("track-list", "native", watch_for_network_subtitle)
mp.add_hook("on_load", 50, on_file_load)
mp.add_key_binding("alt+s", "download-video-and-sub", download_video_and_captured_sub)
msg.info("Jellyfin Stream Downloader script loaded.")
