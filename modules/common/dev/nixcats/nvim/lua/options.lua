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
	cmdheight = 0, -- Cmd height to 0, using noice which doesnt use the bottom command bar
	scrolloff = 2, -- Makes it so screen starts scrolling before cursor reaches edge
	sidescrolloff = 8, -- Handled in VSCode settings
	laststatus = 3,
	-- Folding options
	foldmethod = "indent",
	foldlevel = 99, -- Fold this many indentations (essentially inf)
	-- foldmethod = "expr",
	-- foldexpr = "nvim_treesitter#foldexpr()", -- nvim-treesitter folding
	foldenable = false,
	timeout = true,
	timeoutlen = 300, -- Controls how fast whichkey appears among other things
}

for option, value in pairs(options) do
	vim.opt[option] = value
end
