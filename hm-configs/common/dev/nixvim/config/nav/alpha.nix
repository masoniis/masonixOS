{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "alpha-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "goolord";
          repo = "alpha-nvim";
          rev = "de72250e054e5e691b9736ee30db72c65d560771";
          sha256 = "sNi5qarejYqM4/J7lBZI3gjVLxer5FBPq8K6qjqcMjA=";
        };
      })
    ];

    extraConfigLua = ''
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
      	dashboard.button("e", "   New file", "<cmd>ene <BAR> startinsert <CR>"),
      	dashboard.button("f", "   Find file", "<cmd>cd ~/dev/ | lua Snacks.picker.smart()<CR>"),
      	dashboard.button("r", "   Recent", "<cmd>lua Snacks.picker.recent()<CR>"),
      	dashboard.button("g", "   Grep repo", "<cmd>lua Snacks.picker.grep()<CR>"),
      	dashboard.button("b", "   Projects", "<cmd>lua Snacks.picker.projects()<CR>"),
      	dashboard.button("t", "   Themes", "<cmd>lua Snacks.picker.colorschemes()<CR>"),
      	dashboard.button("q", "󰰲   Quit neovim", "<cmd>qa<CR>"),

      	-- dashboard.button("t", "  > Themes", ":Telescope colorscheme<CR>"),
      	-- dashboard.button("s", "  > System conf", ":e ~/.config/home-manager/flake.nix<CR>"),
      	-- dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
      }

      dashboard.section.footer.val = os.date("  %A, %Y-%m-%d")

      -- Send config to alpha
      alpha.setup(dashboard.opts)

      -- Disable folding on alpha buffer
      vim.cmd([[
        		autocmd FileType alpha setlocal nofoldenable
      ]])
    '';
  };
}
