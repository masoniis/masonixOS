return {
	{
		"stevearc/oil.nvim",
		opts = {
			float = {
				padding = 17,
			},
		},
		-- not sure why but the config isn't being passed properly by lazy automatically?
		config = function(_, opts)
			require("oil").setup(opts)
		end,
		keys = {
			{
				nixCats("binds.files.float"),
				function()
					require("oil").toggle_float()
				end,
				desc = "oil float",
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
			"folke/snacks.nvim",
			"saifulapm/neotree-file-nesting-config",
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
						command = "toggle_node", -- shift enter to toggle fold node instead
					},
				},
			},
			-- custom sort function to "pin" files. Useful imo for things like module files
			sort_function = (function()
				local pinned_files_order = {
					"mod.rs",
					"index.ts",
				}

				local pin_lookup = {}
				for i, name in ipairs(pinned_files_order) do
					pin_lookup[name] = i
				end

				return function(a, b)
					local a_name = vim.fn.fnamemodify(a.path, ":t")
					local b_name = vim.fn.fnamemodify(b.path, ":t")

					local a_pin_index = pin_lookup[a_name]
					local b_pin_index = pin_lookup[b_name]

					-- Rule 0: Directories always come first
					if a.type == "directory" and b.type ~= "directory" then
						return true
					end
					if a.type ~= "directory" and b.type == "directory" then
						return false
					end

					-- Rule 1: If both files are pinned, sort by their order in the list
					if a_pin_index and b_pin_index then
						return a_pin_index < b_pin_index
					end

					-- Rule 2: If only 'a' is pinned, 'a' comes first
					if a_pin_index then
						return true
					end

					-- Rule 3: If only 'b' is pinned, 'b' comes first
					if b_pin_index then
						return false
					end

					-- Rule 4: Neither is pinned, fall back to default sorting
					return a_name < b_name
				end
			end)(),
			filesystem = {
				follow_current_file = { -- intelligently follow current buffer's file
					enabled = true,
				},
				use_libuv_file_watcher = true, -- refresh on file changes (useful for external edits like AI)
			},
		},
		config = function(_, opts)
			-- Setup nesting rules
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
			-- Setup snacks renaming
			local function on_move(data)
				Snacks.rename.on_rename_file(data.source, data.destination)
			end
			local events = require("neo-tree.events")
			opts.event_handlers = opts.event_handlers or {}
			vim.list_extend(opts.event_handlers, {
				{ event = events.FILE_MOVED, handler = on_move },
				{ event = events.FILE_RENAMED, handler = on_move },
			})
			require("neo-tree").setup(opts)
		end,
		keys = {
			{
				nixCats("binds.files.explorer"),
				"<cmd>Neotree toggle filesystem left<cr>",
				desc = "neotree explorer",
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
				nixCats("binds.splits.swap_left"),
				function()
					require("smart-splits").swap_buf_left()
				end,
				desc = "swap buffer leftward",
			},
			{
				nixCats("binds.splits.swap_down"),
				function()
					require("smart-splits").swap_buf_down()
				end,
				desc = "swap buffer downward",
			},
			{
				nixCats("binds.splits.swap_up"),
				function()
					require("smart-splits").swap_buf_up()
				end,
				desc = "swap buffer upward",
			},
			{
				nixCats("binds.splits.swap_right"),
				function()
					require("smart-splits").swap_buf_right()
				end,
				desc = "swap buffer rightward",
			},

			-- moving between splits
			{
				nixCats("binds.splits.move_left"),
				function()
					require("smart-splits").move_cursor_left()
				end,
				desc = "move cursor a window left",
			},
			{
				nixCats("binds.splits.move_down"),
				function()
					require("smart-splits").move_cursor_down()
				end,
				desc = "move cursor a window down",
			},
			{
				nixCats("binds.splits.move_up"),
				function()
					require("smart-splits").move_cursor_up()
				end,
				desc = "move cursor a window up",
			},
			{
				nixCats("binds.splits.move_right"),
				function()
					require("smart-splits").move_cursor_right()
				end,
				desc = "move cursor a window right",
			},

			-- resizing splits, `10<A-h>` will resize by `(10 * config.default_amount)
			{
				nixCats("binds.splits.resize_left"),
				function()
					require("smart-splits").resize_left()
				end,
				desc = "resize window right",
			},
			{
				nixCats("binds.splits.resize_down"),
				function()
					require("smart-splits").resize_down()
				end,
				desc = "resize window down",
			},
			{
				nixCats("binds.splits.resize_up"),
				function()
					require("smart-splits").resize_up()
				end,
				desc = "resize window up",
			},
			{
				nixCats("binds.splits.resize_right"),
				function()
					require("smart-splits").resize_right()
				end,
				desc = "resize window up",
			},
		},
	},
}
