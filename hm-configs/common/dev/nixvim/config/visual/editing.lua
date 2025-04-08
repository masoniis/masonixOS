vim.g.barbar_auto_setup = false

local battery = require("battery")

battery.setup({
	update_rate_seconds = 30,
	show_status_when_no_battery = true, -- Don't show any icon or text when no battery found (desktop for example)
	show_plugged_icon = true,
	show_unplugged_icon = false,
	show_percent = true,
	vertical_icons = false, -- When true icons are vertical, otherwise shows horizontal battery icon
	multiple_battery_selection = 1, -- Which battery to choose when multiple found. "max" or "maximum", "min" or "minimum" or a number to pick the nth battery found (currently linux acpi only)
})

-- insert a space at idx=1, between the battery & its charger icon
local batt_icons = require("battery.icons")
local lil = " "
batt_icons.specific.plugged = lil .. batt_icons.specific.plugged
batt_icons.specific.unplugged = lil .. batt_icons.specific.unplugged

-------- components

local function clock_battery()
	local slimlineHl = require("slimline.highlights")
	local slimlineConf = require("slimline").config
	local time = os.date("%H:%M")
	local batt = battery.get_status_line()
	local content = string.format("%s  %s", batt, time)
	return slimlineHl.hl_component({ primary = content }, slimlineHl.hls.component, slimlineConf.sep)
end

-------- config

require("slimline").setup({
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
			clock_battery,
		},
	},
	spaces = {
		components = "─",
		left = "─",
		right = "─",
	},
})
