return {
	"goolord/alpha-nvim", -- nvim startup screen
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		-- Protected require alpha
		local status_ok, alpha = pcall(require, "alpha")
		if not status_ok then
			print("Status of the plugin Alpha is not good.")
			return
		end

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

		local doomvim = {
			[[                                                                              ]],
			[[=================     ===============     ===============   ========  ========]],
			[[\\ . . . . . . .\\   //. . . . . . .\\   //. . . . . . .\\  \\. . .\\// . . //]],
			[[||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\/ . . .||]],
			[[|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||]],
			[[||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||]],
			[[|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\ . . . . ||]],
			[[||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\_ . .|. .||]],
			[[|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\ `-_/| . ||]],
			[[||_-' ||  .|/    || ||    \|.  || `-_|| ||_-' ||  .|/    || ||   | \  / |-_.||]],
			[[||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \  / |  `||]],
			[[||    `'         || ||         `'    || ||    `'         || ||   | \  / |   ||]],
			[[||            .===' `===.         .==='.`===.         .===' /==. |  \/  |   ||]],
			[[||         .=='   \_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \/  |   ||]],
			[[||      .=='    _-'    `-_  `='    _-'   `-_    `='  _-'   `-_  /|  \/  |   ||]],
			[[||   .=='    _-'          '-__\._-'         '-_./__-'         `' |. /|  |   ||]],
			[[||.=='    _-'                                                     `' |  /==.||]],
			[[=='    _-'                        N E O V I M                         \/   `==]],
			[[\   _-'                                                                `-_   /]],
			[[ `''                                                                      ``' ]],
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
			dashboard.button("f", "  > Find file", ":cd ~/dev/ | Telescope find_files<CR>"),
			dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
			--dashboard.button("b", "  > Bookmarks", ":Telescope marks<CR>"),
			dashboard.button("b", "  > Projects", ":Telescope projects<CR>"),
			dashboard.button("L", "󰧑  > Leetcode", ":Leet<CR>"),

			dashboard.button("t", "  > Themes", ":Telescope colorscheme<CR>"),
			dashboard.button("p", "  > Plugins", ":Lazy<CR>"),

			-- dashboard.button("s", "  > System conf", ":e ~/.config/home-manager/flake.nix<CR>"),
			dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),

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
	end,
}
