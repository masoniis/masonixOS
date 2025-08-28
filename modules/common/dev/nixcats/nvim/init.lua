require("nixCats")

-- General options --
require("autocmds")
require("keymaps")
require("options")

-- Plugins --
require("plugins.colorscheme")

require("plugins.snacks")
require("plugins.alpha") -- depends on 'snacks' for buttons

-- TODO: Follow this:
-- https://github.com/BirdeeHub/nixCats-nvim/blob/main/templates/kickstart-nvim/init.lua
-- Uses lazy style plugin loading
