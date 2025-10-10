return {
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
				},
			})

			-- Basic WESL support until tooling (wgsl analyzer) is more advanced.
			vim.treesitter.language.register("wgsl", "wesl")
			vim.filetype.add({
				extension = {
					wesl = "wesl",
				},
			})
		end,
	},
}
