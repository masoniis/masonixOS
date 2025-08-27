local function map(m, k, v, d)
	d = d or "" -- description, optional parameter
	vim.keymap.set(m, k, v, { silent = true, desc = d ~= "" and d or nil })
end

-- Map leader to nothing to make sure it is empty
map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--    normal_mode = "n",
--    insert_mode = "i",
--    visual_mode = "v",
--    visual_block_mode = "x",
--   	term_mode = "t",
--		command_mode = "c",

-----------------
-- Normal mode --
-----------------
map("n", "j", "gj") -- Move through visual lines instead of logical lines
map("n", "k", "gk")

map("n", "<leader>fn", "<cmd>new<cr>", "New file") -- Make new file
-- map("n", "<leader>F", "<cmd>lua vim.lsp.buf.format {async = false}<cr>", "format code") -- Format mapping

map("n", "<leader>cd", "<cmd>cd %:h<cr>", "change file dir") -- Format mapping

-- map("n", "<C-,>", "<cmd>bprevious<cr>", "Navigate back") -- Navigate back buffer like in obsidian

-----------------
-- Visual mode --
-----------------
-- map("v", "
-- map("v", "<A-j>", ":m .+1<CR>==")
-- map("v", "p", '"_dP') -- When pasting, don't cut text pasted over
--
-- --- Terminal mode to navigate in and out
map("t", "<esc>", [[<C-\><C-n>]])
-- -- Having this keybind makes normal j navigationi n terminal slow
map("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
map("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
map("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
map("t", "<C-l>", [[<Cmd>wincmd l<CR>]])
map("t", "<C-w>", [[<C-\><C-n><C-w>]])
