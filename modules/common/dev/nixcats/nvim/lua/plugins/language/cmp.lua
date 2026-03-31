return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets", "fang2hou/blink-copilot", "xzbdmw/colorful-menu.nvim" },

	version = "1.*",
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "super-tab",
			["<C-l>"] = {
				function(cmp)
					cmp.show({ providers = { "copilot" } })
					return true
				end,
			},
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = { auto_show = true, auto_show_delay_ms = 2000 },
			menu = {
				draw = {
					columns = { { "kind_icon" }, { "label", gap = 1 } },
					components = {
						label = {
							text = function(ctx)
								return require("colorful-menu").blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require("colorful-menu").blink_components_highlight(ctx)
							end,
						},
					},
				},
			},
		},

		sources = {
			default = { "snippets", "lsp", "path", "buffer" },

			providers = {
				copilot = {
					async = true,
					module = "blink-copilot",
					name = "copilot",
					score_offset = 100,
					opts = {
						max_completions = 3,
						max_attempts = 4,
						kind = "Copilot",
						debounce = 750,
						auto_refresh = {
							backward = true,
							forward = true,
						},
					},
				},
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
