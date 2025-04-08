local wezterm = require("wezterm")
local keybinds = require("keybinds")
local scheme = wezterm.get_builtin_color_schemes()["tokyonight"]

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Might be best frontend, but also fixes nix mc bug that was on main 9/19/24
config.front_end = "WebGpu"
config.enable_kitty_graphics = true

-- Aesthetics
config.color_scheme = "tokyonight"
config.default_cursor_style = "BlinkingBar"
config.hide_tab_bar_if_only_one_tab = true
config.animation_fps = 32
config.font = wezterm.font("FiraCode Nerd Font")

-- Convenience
config.warn_about_missing_glyphs = true
config.window_close_confirmation = "NeverPrompt"
config.native_macos_fullscreen_mode = true

config.underline_position = -5

-- Removing the weird window padding from terminal
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

config.window_frame = {
	font = wezterm.font("Roboto", { weight = "Bold" }),
	font_size = 12.0,
	-- tab bar BG color based on window focused/unfocused
	active_titlebar_bg = "#000000",
	inactive_titlebar_bg = "#000000",
}

config.colors = {
	tab_bar = {
		active_tab = { -- Tab with current focus
			bg_color = scheme.background,
			fg_color = scheme.brights[3], -- green
		},

		-- The divider between tabs
		inactive_tab_edge = "#000000",

		inactive_tab = { -- Tabs without focus
			bg_color = scheme.background,
			fg_color = scheme.foreground,
		},

		inactive_tab_hover = {
			bg_color = scheme.background,
			fg_color = scheme.brights[4], -- yellow
		},

		-- The new tab button that let you create new tabs
		new_tab = {
			bg_color = "#000000",
			fg_color = scheme.foreground,
		},

		-- You can configure some alternate styling when the mouse pointer
		-- moves over the new tab button
		new_tab_hover = {
			bg_color = "#000000",
			fg_color = scheme.brights[3], -- green
		},
	},
	compose_cursor = "orange",
}

-- INFO: Keybinds
config.keys = keybinds.default

return config
