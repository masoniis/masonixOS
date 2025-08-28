if not nixCats("general") then
	return
end

local alpha = require("alpha")

-- Setup for themes dashboard
alpha.setup(require("alpha.themes.dashboard").config)
local dashboard = require("alpha.themes.dashboard")

-- Set header
local corpsvim = {
	[[                                                                   ]],
	[[ ███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄   ]],
	[[ ███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄ ]],
	[[ ███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
	[[ ███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
	[[ ███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███ ]],
	[[ ███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███ ]],
	[[ ███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███ ]],
	[[  ▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀  ]],
	[[                                                                   ]],
}

local isovim = {
	[[                                                                                   ]],
	[[     /\__\         /\  \         /\  \         /\__\          ___        /\__\     ]],
	[[    /::|  |       /::\  \       /::\  \       /:/  /         /\  \      /::|  |    ]],
	[[   /:|:|  |      /:/\:\  \     /:/\:\  \     /:/  /          \:\  \    /:|:|  |    ]],
	[[  /:/|:|  |__   /::\~\:\  \   /:/  \:\  \   /:/__/  ___      /::\__\  /:/|:|__|__  ]],
	[[ /:/ |:| /\__\ /:/\:\ \:\__\ /:/__/ \:\__\  |:|  | /\__\  __/:/\/__/ /:/ |::::\__\ ]],
	[[ \/__|:|/:/  / \:\~\:\ \/__/ \:\  \ /:/  /  |:|  |/:/  / /\/:/  /    \/__/~~/:/  / ]],
	[[     |:/:/  /   \:\ \:\__\    \:\  /:/  /   |:|__/:/  /  \::/__/           /:/  /  ]],
	[[     |::/  /     \:\ \/__/     \:\/:/  /     \::::/__/    \:\__\          /:/  /   ]],
	[[     /:/  /       \:\__\        \::/  /       ~~~~         \/__/         /:/  /    ]],
	[[     \/__/         \/__/         \/__/                                   \/__/     ]],
	[[                                                                                   ]],
}

local sharpvim = {
	[[                                                                       ]],
	[[                                                                     ]],
	[[       ████ ██████           █████      ██                     ]],
	[[      ███████████             █████                             ]],
	[[      █████████ ███████████████████ ███   ███████████   ]],
	[[     █████████  ███    █████████████ █████ ██████████████   ]],
	[[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
	[[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
	[[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
	[[                                                                       ]],
}

local headers = { corpsvim, isovim, sharpvim }

local function header_chars()
	math.randomseed(os.time())
	return headers[math.random(#headers)]
end

dashboard.section.header.val = header_chars()

-- Set menu
dashboard.section.buttons.val = {
	dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("f", "  > Find file", ":lua Snacks.picker.smart()<CR>"),
	dashboard.button("r", "  > Recent", ":lua Snacks.picker.recent()<CR>"),

	dashboard.button("t", "  > Themes", ":lua Snacks.picker.colorschemes()<CR>"),
	dashboard.button("p", "  > Plugins", ":NixCats pawsible<CR>"),
	dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
}

dashboard.section.footer.val = os.date("  %A, %Y-%m-%d")

-- Send config to alpha
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
    		autocmd FileType alpha setlocal nofoldenable
		]])

vim.api.nvim_create_autocmd("User", {
	pattern = "LazyVimStarted",
	callback = function()
		local stats = require("lazy").stats()
		local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
		dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
		pcall(vim.cmd.AlphaRedraw)
	end,
})
