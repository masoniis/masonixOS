local api = vim.api

-- highlight on yank
local yankGrp = api.nvim_create_augroup("YankHighlight", { clear = true })
api.nvim_create_autocmd("TextYankPost", {
	command = "silent! lua vim.highlight.on_yank()",
	group = yankGrp,
})

-- check if we need to reload the file when it changed
api.nvim_create_autocmd("FocusGained", { command = [[:checktime]] })

-- don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- remove line numbers in a terminal
api.nvim_create_autocmd("TermOpen", { command = [[setlocal nonumber norelativenumber]] })

-- clear log file on launch nvim
vim.api.nvim_create_autocmd("VimEnter", {
	desc = "Clear LSP log on startup",
	callback = function()
		local log_path = vim.lsp.get_log_path()
		if vim.fn.filereadable(log_path) == 1 then
			os.remove(log_path)
		end
	end,
})
