return {
	{
		"romgrk/barbar.nvim", -- file "tabs"
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		event = { "BufReadPre", "BufNewFile" },
		init = function()
			vim.g.barbar_auto_setup = false
			vim.keymap.set("n", "<leader>bc", "<cmd>BufferClose!<cr>", { desc = "close buffer" })
			vim.keymap.set("n", "<leader>bp", "<cmd>BufferPrevious<cr>", { desc = "previous buffer" })
			vim.keymap.set("n", "<leader>bn", "<cmd>BufferNext<cr>", { desc = "next buffer" })
		end,
		opts = {
			-- highlight_visible = false,
			auto_hide = 1, -- Hide if 1 or less tabs
			icons = {
				separator = { left = "┃", right = "" },
				separator_at_end = false,
			},
			sidebar_filetypes = {
				["neo-tree"] = { event = "BufWipeout", text = "file tree" },
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim", -- file explorer
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
	},
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		-- WARNING: warning warnging WARNING
		-- FIX: fix fix fix fix fix  FIX
		-- TODO: do todo something   TODO
		-- HACK: hack something hack HACK
		-- INFO: SOME INFORMATION    INFO
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
}
