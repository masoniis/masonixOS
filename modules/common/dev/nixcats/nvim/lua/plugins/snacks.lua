return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		explorer = { enabled = false }, -- neotree superior
		indent = { enabled = true },
		input = { enabled = true },
		picker = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true, easing = "inQuad" },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		image = { enabled = true },

		dashboard = {
			enabled = true,
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{
					pane = 2,
					icon = " ",
					title = "Recent Files",
					section = "recent_files",
					indent = 2,
					padding = 1,
				},
				{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
				{
					pane = 2,
					icon = " ",
					title = "Git Status",
					section = "terminal",
					enabled = function()
						return Snacks.git.get_root() ~= nil
					end,
					cmd = "git status --short --branch --renames",
					height = 5,
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				},
				{ section = "startup" },
			},
			preset = {
				keys = {
					{ icon = " ", key = "f", desc = "Find file", action = ":lua Snacks.dashboard.pick('files')" },
					{
						icon = " ",
						key = "g",
						desc = "Find text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ":lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						icon = "󰒲 ",
						key = "p",
						desc = "Plugins",
						action = ":Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
		},
	},
	keys = {
		-- Dashboard
		{ "<leader><leader><leader>", "<cmd>lua Snacks.dashboard()<cr>", desc = "snacks dashboard" },
		-- Terminals
		{ "<leader>tl", "<cmd>lua Snacks.lazygit()<cr>", desc = "lazygit" },
		-- Pickers
		{ "<leader>ff", ":lua Snacks.picker.smart()<cr>", desc = "find files" },
		{ "<leader>fr", ":lua Snacks.picker.recent()<cr>", desc = "find recent" },
		{ "<leader>fn", ":lua Snacks.picker.notifications()<cr>", desc = "find notifications" },
		{ "<leader>fg", ":lua Snacks.picker.git_files()<cr>", desc = "find git files" },
		{ "<leader>fG", ":lua Snacks.picker.git_files()<cr>", desc = "find grep open buffers" },
		{
			"<leader>e",
			"<cmd>lua Snacks.explorer()<cr>",
			desc = "Snacks explorer",
		},
		-- System mapping
		{ "<leader>sg", ":lua Snacks.gitbrowse.open()<cr>", desc = "open local repo in github" },
		-- Misc
		{ "<leader>gb", ":lua Snacks.git.blame_line()<cr>", desc = "git blame line" },
	},
}
