return {
	{
		"justinhj/battery.nvim",
		opts = {
			update_rate_seconds = 30,
			show_status_when_no_battery = true, -- Don't show any icon or text when no battery found (desktop for example)
			show_plugged_icon = true,
			show_unplugged_icon = false,
			show_percent = true,
			vertical_icons = false, -- When true icons are vertical, otherwise shows horizontal battery icon
			multiple_battery_selection = 1, -- Which battery to choose when multiple found. "max" or "maximum", "min" or "minimum" or a number to pick the nth battery found (currently linux acpi only)
		},
	},
	{
		"sschleemilch/slimline.nvim",
		init = function()
			vim.cmd("highlight Slimline guifg=#101012 guibg=#101012")
		end,
		opts = {
			components = { -- Choose components and their location
				left = {
					"mode",
					"path",
					"git",
				},
				center = {
					"recording",
				},
				right = {
					"diagnostics",
					"filetype_lsp",
					function(active)
						local time = os.date("%H:%M")
						local batt = require("battery").get_status_line()
						local content = string.format("%s  %s", batt, time)
						return Slimline.highlights.hl_component(
							{ primary = content },
							Slimline.highlights.hls.components["path"],
							Slimline.get_sep("path"),
							"right", -- flow direction (on which side the secondary part will be rendered)
							active, -- whether the component is active or not
							"fg" -- style to use
						)
					end,
				},
			},
			spaces = {
				components = "─",
				left = "─",
				right = "─",
			},
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		opts = {
			presets = {
				command_palette = true,
				inc_rename = true,
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
	{
		"levouh/tint.nvim",
		opts = {
			tint = -15,
			saturation = 0.1,
			tint_background_colors = true, -- Tint background portions of highlight groups
			-- highlight_ignore_patterns = { "WinSeparator" }, -- Highlight group patterns to ignore, see `string.find`
			window_ignore_function = function(winid)
				local is_floating = vim.api.nvim_win_get_config(winid).relative ~= ""

				-- Next, get the buffer name associated with the window
				local bufid = vim.api.nvim_win_get_buf(winid)
				local bufname = vim.api.nvim_buf_get_name(bufid)

				-- Check if the buffer name contains "FloatermSidebar"
				local is_floaterm_sidebar = string.find(bufname, "FloatermSidebar", 1, true)

				return is_floating or is_floaterm_sidebar
			end,
		},
		init = function()
			-- Fixes issues where closing a toggleterm like lazygit
			-- results in every viewed buffer being tinted
			vim.api.nvim_create_autocmd("TermClose", {
				desc = "Untint terminal window on close",
				callback = function()
					vim.defer_fn(function()
						require("tint").untint(vim.api.nvim_get_current_win())
					end, 10)
				end,
			})
		end,
	},
	{
		"nvzone/minty",
		cmd = { "Shades", "Huefy" },
		name = "nvzone-minty", -- required for because the nix plugin names it this
		keys = {
			-- TODO: temp binds will adjust once thought through
			{ "<leader>uc", "<cmd>Shades<cr>", desc = "Change color scheme shade" },
			{ "<leader>uh", "<cmd>Huefy<cr>", desc = "Change color scheme hue" },
		},
	},
}
