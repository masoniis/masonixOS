return {
	{
		"sschleemilch/slimline.nvim",
		name = "slimline-nvim", -- required for nixcats to recognize
		opts = {},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		opts = {
			presets = {
				command_palette = true,
			},
		},
	},
}
