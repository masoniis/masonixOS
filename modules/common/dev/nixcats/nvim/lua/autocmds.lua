local api = vim.api

-- Highlight on yank
local yankGrp = api.nvim_create_augroup("YankHighlight", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
	command = "silent! lua vim.highlight.on_yank()",
	group = yankGrp,
})

-- Check if we need to reload the file when it changed
api.nvim_create_autocmd("FocusGained", { command = [[:checktime]] })

-- Don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- Auto enter terminal when tabbing into a terminal pane
api.nvim_create_autocmd("TermOpen", { command = [[startinsert]] })
api.nvim_create_autocmd("TermOpen", { command = [[setlocal nonumber norelativenumber]] }) --- Remove line numbers in a terminal
-- api.nvim_create_autocmd("TermOpen", { command = [[set ma]] }) --- SOMEWHAT DANGEROUS: sets terminal buffers to modifiable to take use of vim -a vi
-- api.nvim_create_autocmd("BufEnter,WinEnter", { pattern = { "term://*" }, command = "startinsert", nested = true }) -- Inter insert mode on window terminal focus

-- When entering command mode, set height to 1 in order to shift statusline up so it remains visible
api.nvim_create_autocmd("CmdlineEnter", {
	command = ":set cmdheight=1",
})

-- When leaving, set height back to 0 to hide command line
api.nvim_create_autocmd("CmdlineLeave", {
	command = ":set cmdheight=0",
})

-- Highlight cursorline in active windows only
local cl_var = "auto_cursorline"

vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
	group = vim.api.nvim_create_augroup("enable_auto_cursorline", { clear = true }),
	callback = function()
		local ok, cl = pcall(vim.api.nvim_win_get_var, 0, cl_var)
		if ok and cl then
			vim.api.nvim_win_del_var(0, cl_var)
			vim.o.cursorline = true
		end
	end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
	group = vim.api.nvim_create_augroup("disable_auto_cursorline", { clear = true }),
	callback = function()
		local cl = vim.o.cursorline
		if cl then
			vim.api.nvim_win_set_var(0, cl_var, cl)
			vim.o.cursorline = false
		end
	end,
})
