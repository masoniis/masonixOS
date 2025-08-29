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
map("n", "<leader>cd", "<cmd>cd %:h<cr>", "change file dir") -- Format mapping
map("n", "<C-q>", "<cmd>close<cr>", "close")

-----------------
-- Visual mode --
-----------------

map("v", "p", '"_dP') -- When pasting over a selection, don't copy the selected text to the clipboard
map("t", "<C-q>", "<cmd>close<cr>", "close")

-- Terminal mode to navigate in and out
map("t", "<esc>", [[<C-\><C-n>]])
map("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
map("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
map("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
map("t", "<C-l>", [[<Cmd>wincmd l<CR>]])
map("t", "<C-w>", [[<C-\><C-n><C-w>]])
