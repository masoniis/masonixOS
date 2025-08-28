return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
			{ "saifulapm/neotree-file-nesting-config", name = "neotree-nesting-config-nvim" },
		},
		lazy = false, -- neo-tree will lazily load itself
		---@module 'neo-tree'
		---@type neotree.Config
		opts = {
			popup_border_style = "", -- uses 'winborder' on Neovim v0.11+
			window = {
				mappings = {
					["<space>"] = false, -- disable space for toggle node, interferes leader
					["<S-CR>"] = {
						command = "toggle_node", -- shift enter to toggle fold node
					},
				},
			},
		},
		config = function(_, opts)
			opts.nesting_rules = (function()
				local rules = require("neotree-file-nesting-config").nesting_rules
				rules["protobuf"] = {
					pattern = "(.*).proto",
					files = { "%1%.pb.dart", "%1%.pbenum.dart", "%1%.pbjson.dart", "%1%.pbserver.dart" },
				}
				rules["flake"] = {
					pattern = "flake%.nix$",
					files = { "flake%.lock", "treefmt%.nix" },
				}
				return rules
			end)()
			require("neo-tree").setup(opts)
		end,
		keys = {
			{
				"<leader>e",
				"<cmd>Neotree toggle filesystem left<cr>",
				desc = "neotree explorer",
			},
			{
				"<leader>E",
				"<cmd>Neotree toggle float<cr>",
				desc = "neotree float",
			},
		},
	},
	{
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
	},
}
