return {
	"romgrk/barbar.nvim",
	dependencies = {
		"lewis6991/gitsigns.nvim", -- OPTIONAL: for git status
		"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
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
}
