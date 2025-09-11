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

			{ nixCats("binds.find.group"), group = "find" },
			{ nixCats("binds.lsp.group"), group = "lang" },
			{ nixCats("binds.system.group"), group = "system" },
			{ nixCats("binds.terminals.group"), group = "terminal" },
			{ nixCats("binds.debug.group"), group = "debug" },
			{ nixCats("binds.util.group"), group = "util" },
		})
	end,
	keys = {
		{
			nixCats("binds.which_key"),
			function()
				require("which-key").show({ global = false })
			end,
			desc = "buffer local keymaps (which-key)",
		},
	},
}
