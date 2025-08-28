return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		layout = {
			align = "center", -- align columns left, center or right
		},
		win = {
			border = "single", -- none, single, double, shadow
			margin = { 1, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
			padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
		},
	},
	config = function()
		local wk = require("which-key")
		wk.add({
			{ "<leader>a", group = "ai" },
			{ "<leader>b", group = "buffer" },
			{ "<leader>f", group = "file" },
			{ "<leader>l", group = "lang" },
			{ "<leader>s", group = "system" },
			{ "<leader>t", group = "terminal", icon = "terminal" },
		})
	end,
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "buffer local keymaps (which-key)",
		},
	},
}
