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
	cmdheight = 0, -- Cmd height to 0, using noice which doesnt use the bottom command bar
	scrolloff = 2, -- Makes it so screen starts scrolling before cursor reaches edge
	sidescrolloff = 8, -- Handled in VSCode settings
	laststatus = 3,

	-- folding options
	foldmethod = "indent",
	foldlevel = 99, -- fold this many indentations (essentially inf)
	foldenable = false,
	timeout = true,
	timeoutlen = 300, -- controls how fast whichkey appears among other things
	fillchars = "eob: ", -- fill gutter with empty-ness on empty lines (default ~)

	-- enable project-local configuration (eg project/.nvim.lua)
	exrc = true,
	secure = true,
}

for option, value in pairs(options) do
	vim.opt[option] = value
end
