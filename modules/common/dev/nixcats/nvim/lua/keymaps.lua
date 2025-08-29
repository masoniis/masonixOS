local function map(m, k, v, d)
	d = d or "" -- description, optional parameter
	vim.keymap.set(m, k, v, { silent = true, desc = d ~= "" and d or nil })
end

-- Map leader to space
map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-----------------
-- Normal mode --
-----------------
map("n", "j", "gj") -- Move through visual lines instead of logical lines
map("n", "k", "gk")

map("n", "<leader>fn", "<cmd>new<cr>", "New file") -- Make new file
map("n", "<leader>cd", "<cmd>cd %:h<cr>", "Change to file directory") -- Change directory
map("n", "<C-q>", "<cmd>close<cr>", "Close buffer")

-- System interaction keymaps
map("n", "<leader>sr", function()
	local file = vim.fn.expand("%:p")
	if vim.fn.filereadable(file) ~= 1 then
		vim.notify("No file to reveal", vim.log.levels.WARN)
		return
	end

	local sysname = vim.loop.os_uname().sysname
	local cmd
	if sysname == "Darwin" then
		cmd = 'open -R "' .. file .. '"'
	elseif sysname == "Windows_NT" then
		-- On Windows, we need to escape backslashes for the shell
		local escaped_file = file:gsub("\\", "\\\\")
		cmd = 'explorer /select,"' .. escaped_file .. '"'
	else -- Linux
		local dir = vim.fn.fnamemodify(file, ":h")
		cmd = 'xdg-open "' .. dir .. '"'
	end
	os.execute(cmd)
end, "Reveal in system explorer")

map("n", "<leader>sf", function()
	local file = vim.fn.expand("%:p")
	if file == "" or vim.fn.filereadable(file) ~= 1 then
		vim.notify("No file path to copy", vim.log.levels.WARN)
		return
	end

	local sysname = vim.loop.os_uname().sysname
	local copy_cmd

	if sysname == "Darwin" then
		copy_cmd = 'echo "' .. file .. '" | pbcopy'
	elseif sysname == "Windows_NT" then
		copy_cmd = "echo " .. file .. " | clip"
	else -- Linux
		if vim.fn.executable("wl-copy") == 1 then
			copy_cmd = 'echo "' .. file .. '" | wl-copy'
		elseif vim.fn.executable("xclip") == 1 then
			copy_cmd = 'echo "' .. file .. '" | xclip -selection clipboard'
		else
			vim.notify("No clipboard utility (wl-copy or xclip) found", vim.log.levels.ERROR)
			return
		end
	end

	os.execute(copy_cmd)
	vim.notify("Copied: " .. file)
end, "Copy system file path")

map("n", "<leader>sb", function()
	local file = vim.fn.expand("%:p")
	if file == "" then
		vim.notify("No file to open in browser", vim.log.levels.WARN)
		return
	end

	-- Convert file path to URL (file:// protocol) and encode spaces
	local url = "file://" .. file:gsub(" ", "%%20")
	local sysname = vim.loop.os_uname().sysname
	local open_cmd

	if sysname == "Darwin" then
		open_cmd = 'open "' .. url .. '"'
	elseif sysname == "Windows_NT" then
		open_cmd = 'start "" "' .. url .. '"'
	else -- Linux
		if vim.fn.executable("xdg-open") == 1 then
			open_cmd = 'xdg-open "' .. url .. '"'
		else
			vim.notify("No browser opener (xdg-open) found", vim.log.levels.ERROR)
			return
		end
	end

	local ok, _, code = vim.fn.system(open_cmd)
	if ok == 0 then
		vim.notify("Opened in browser: " .. file)
	else
		vim.notify("Failed to open in browser (exit code: " .. code .. ")", vim.log.levels.ERROR)
	end
end, "Open in web browser")

map("n", "<leader>sc", function()
	local file = vim.fn.expand("%:p")
	if file == "" or vim.fn.filereadable(file) ~= 1 then
		vim.notify("No valid file to copy", vim.log.levels.WARN)
		return
	end

	local sysname = vim.loop.os_uname().sysname
	local cmd

	if sysname == "Darwin" then
		cmd = "osascript -e 'set the clipboard to (POSIX file \"" .. file .. "\")'"
	elseif sysname == "Windows_NT" then
		cmd = "powershell.exe -Command \"Set-Clipboard -Path '" .. file .. "'\""
	else -- Linux
		if vim.fn.executable("wl-copy") == 1 then
			cmd = "printf 'file://" .. file .. "' | wl-copy --type text/uri-list"
		elseif vim.fn.executable("xclip") == 1 then
			cmd = "printf 'file://" .. file .. "' | xclip -selection clipboard -t text/uri-list"
		else
			vim.notify("Clipboard file copy unsupported on this platform", vim.log.levels.ERROR)
			return
		end
	end

	os.execute(cmd)
	vim.notify("Copied file reference to clipboard")
end, "Copy file to clipboard")

-----------------
-- Visual mode --
-----------------
map("v", "p", '"_dP') -- When pasting over a selection, don't copy the selected text
map("v", "<", "<gv") -- Indent selection and stay in visual mode
map("v", ">", ">gv") -- Dedent selection and stay in visual mode

-----------------
-- Insert mode --
-----------------
-- Add mappings for insert mode here if needed

-------------------
-- Terminal mode --
-------------------
map("t", "<esc>", [[<C-\><C-n>]]) -- Exit terminal mode
map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], "Terminal left")
map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], "Terminal down")
map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], "Terminal up")
map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], "Terminal right")
map("t", "<C-w>", [[<C-\><C-n><C-w>]], "Terminal window command")
