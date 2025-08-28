return {
	"mrjones2014/smart-splits.nvim",
	opts = {
		cursor_follows_swapped_bufs = true, -- When swapping, follow with the swap window (default false)
		default_amount = 1, -- set default resize interval to 1 instead of 3
	},
	keys = {
		{
			"<leader><leader>h",
			function()
				require("smart-splits").swap_buf_left()
			end,
			desc = "swap buffer leftward",
		},
		{
			"<leader><leader>j",
			function()
				require("smart-splits").swap_buf_down()
			end,
			desc = "swap buffer downward",
		},
		{
			"<leader><leader>k",
			function()
				require("smart-splits").swap_buf_up()
			end,
			desc = "swap buffer upward",
		},
		{
			"<leader><leader>l",
			function()
				require("smart-splits").swap_buf_right()
			end,
			desc = "swap buffer rightward",
		},

		-- moving between splits
		{
			"<C-h>",
			function()
				require("smart-splits").move_cursor_left()
			end,
			desc = "move cursor a window left",
		},
		{
			"<C-j>",
			function()
				require("smart-splits").move_cursor_down()
			end,
			desc = "move cursor a window down",
		},
		{
			"<C-k>",
			function()
				require("smart-splits").move_cursor_up()
			end,
			desc = "move cursor a window up",
		},
		{
			"<C-l>",
			function()
				require("smart-splits").move_cursor_right()
			end,
			desc = "move cursor a window right",
		},

		-- resizing splits, `10<A-h>` will resize by `(10 * config.default_amount)
		{
			"<A-h>",
			function()
				require("smart-splits").resize_left()
			end,
			desc = "resize window right",
		},
		{
			"<A-j>",
			function()
				require("smart-splits").resize_down()
			end,
			desc = "resize window down",
		},
		{
			"<A-k>",
			function()
				require("smart-splits").resize_up()
			end,
			desc = "resize window up",
		},
		{
			"<A-l>",
			function()
				require("smart-splits").resize_right()
			end,
			desc = "resize window up",
		},
	},
}
