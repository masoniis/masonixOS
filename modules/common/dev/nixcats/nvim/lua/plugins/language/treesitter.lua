return {
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			-- basic WESL support until tooling (wgsl analyzer) is more advanced.
			vim.treesitter.language.register("wgsl", "wesl")
			vim.filetype.add({
				extension = {
					wesl = "wesl",
				},
			})
		end,
	},
}
