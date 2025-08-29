return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = "<C-l>", -- Use Ctrl+L to accept suggestions
				dismiss = "<C-h>", -- Use Ctrl+H to dismiss suggestions
			},
		},
		panel = {
			enabled = true, -- Shows a panel with multiple suggestions
		},
	},
}
