return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		layout = {
			preset = "modern",
			-- preset = "helix",
		},
	},
	config = function(_, opts)
		local wk = require("which-key")

		wk.setup(opts)

		wk.add({
			{ "<leader>a", group = "ai" },
			{ "<leader>b", group = "buffer" },
			{ "<leader>f", group = "file" },
			{ "<leader>l", group = "lang" },
			{ "<leader>s", group = "system" },
			{ "<leader>t", group = "terminal" },
			{ "<leader>d", group = "debug" },
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
