-- MPV SCRIPT: Simple FFSubSync Wrapper

local utils = require("mp.utils")
local msg = require("mp.msg")
local options = require("mp.options")

-- INFO: ----------------
--         config
-- ----------------------

local opts = {
	ffsubsync_bin = "ffsubsync",
}

options.read_options(opts, "simpleSubSync")

-- INFO: --------------------
--         sync logic
-- --------------------------

local function sync_current_sub()
	local video_path = mp.get_property("path")
	local track_list = mp.get_property_native("track-list")
	local sub_path = nil

	-- SEARCH STEP 1: Look for a SELECTED external track
	for _, track in ipairs(track_list) do
		if track.type == "sub" and track.selected and track.external then
			if track["external-filename"] then
				sub_path = track["external-filename"]
				break
			end
		end
	end

	-- SEARCH STEP 2: If we didn't find one, pick the FIRST available external track
	if not sub_path then
		for _, track in ipairs(track_list) do
			if track.type == "sub" and track.external then
				if track["external-filename"] then
					sub_path = track["external-filename"]
					msg.info("No external sub selected. Auto-selecting: " .. sub_path)
					break
				end
			end
		end
	end

	-- Sanity Checks
	if not video_path or not utils.file_info(video_path) then
		mp.osd_message("Error: No video file found", 4)
		return
	end
	if not sub_path then
		mp.osd_message("Error: No external subtitle found to sync.", 4)
		return
	end

	-- Construct Output Filename
	local retimed_path = sub_path:gsub("(%.%w+)$", "_retimed.srt")

	-- The Command
	local args = {
		opts.ffsubsync_bin,
		video_path,
		"-i",
		sub_path,
		"-o",
		retimed_path,
		"--max-offset-seconds",
		"300",
		"--gss",
	}

	msg.info("Running: " .. table.concat(args, " "))
	mp.osd_message("Syncing Subtitles...", 10)

	-- Run Async
	mp.command_native_async({
		name = "subprocess",
		args = args,
		playback_only = false,
		capture_stdout = true,
		capture_stderr = true,
	}, function(success, res, err)
		msg.info("=== FFSUBSYNC LOG START ===")

		if res.stdout and res.stdout ~= "" then
			msg.info(res.stdout)
		end

		if res.stderr and res.stderr ~= "" then
			msg.info(res.stderr)
		end

		msg.info("=== FFSUBSYNC LOG END ===")

		-- CHECK SUCCESS
		if success and res.status == 0 then
			mp.osd_message("Sync Success! Loading new track...", 3)
			mp.commandv("sub-add", retimed_path, "select")
		else
			mp.osd_message("Sync Failed! Check console (~)", 5)
			msg.error("Exit Code: " .. (res.status or "unknown"))
			if err then
				msg.error("MPV Error: " .. err)
			end
		end
	end)
end

-- Bindings
mp.register_script_message("run-ffsubsync", sync_current_sub)

msg.info("Script loaded with binary: " .. opts.ffsubsync_bin)
