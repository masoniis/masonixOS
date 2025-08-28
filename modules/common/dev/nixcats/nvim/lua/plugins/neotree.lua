return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{
			"<leader>e",
			"<cmd>Neotree filesystem toggle left<cr>",
			desc = "neotree explorer",
		},
		{
			"<leader>E",
			"<cmd>Neotree float toggle<cr>",
			desc = "neotree float",
		},
	},
}
