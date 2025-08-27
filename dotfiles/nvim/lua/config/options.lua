local options = {
	termguicolors = true,
	number = true,
	numberwidth = 5,
	cursorline = true,
	clipboard = "unnamedplus", -- Neovim and OS clipboard are friends now
	tabstop = 2, -- Tab length 4 spaces
	shiftwidth = 2, -- 4 spaces when indenting with '>'
	smartcase = true,
	ignorecase = true,
	-- Fold based on indents rather than manual
	cmdheight = 0, -- When a command is not being typed, height is 0 instead of 1 line
	scrolloff = 2, -- Handled in VSCode settings, makes it so it starts scrolling before cursor reaches e
	sidescrolloff = 8, -- Handled in VSCode settings
	laststatus = 3,
	-- Folding options
	foldmethod = "indent",
	foldlevel = 99, -- Fold this many indentations (essentially inf)
	-- foldmethod = "expr",
	-- foldexpr = "nvim_treesitter#foldexpr()", -- nvim-treesitter folding
	foldenable = false,
	-- timeoutlen = 100, -- Controls how fast whichkey appears among other things
}

for option, value in pairs(options) do
	vim.opt[option] = value
end
