if not nixCats("general") then
	return
end

-- dotfiles/nvim/lua/config/alpha.lua
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

-- Set up the dashboard header
dashboard.section.header.val = {
	"███╗   ██╗ ██╗   ██╗██╗  ██╗ █████╗ ",
	"████╗  ██║ ██║   ██║██║  ██║██╔══██╗",
	"██╔██╗ ██║ ██║   ██║███████║███████║",
	"██║╚██╗██║ ██║   ██║██╔══██║██╔══██║",
	"██║ ╚████║ ╚██████╔╝██║  ██║██║  ██║",
	"╚═╝  ╚═══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝",
}

-- Set up buttons for common actions
dashboard.section.buttons.val = {
	dashboard.button("f", "🔎 Find File", ":Telescope find_files <CR>"),
	dashboard.button("n", "📄 New File", ":new <CR>"),
	dashboard.button("r", "📖 Recent Files", ":Telescope oldfiles <CR>"),
	dashboard.button("q", "❌ Quit", ":qa <CR>"),
}

alpha.setup(dashboard.opts)
