{ ... }:
{
  programs.nixvim = {
    plugins = {
      friendly-snippets.enable = true;
      luasnip = {
        enable = true;
        settings = {
          enable_autosnippets = true;
          exit_roots = false;
          keep_roots = true;
          link_roots = true;
          update_events = [
            "TextChanged"
            "TextChangedI"
          ];
        };
      };
      cmp_luasnip.enable = true;
      copilot-lua.enable = true;
      copilot-lua.settings = {
        panel.enabled = false;
        suggestion.enabled = false;
      };
      copilot-cmp.enable = true;
      copilot-cmp.settings.fix_pairs = true;
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "copilot"; }
            { name = "ai"; }
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" =
              #Lua
              ''
                cmp.mapping({
                  i = function(fallback)
                    if cmp.visible() and cmp.get_active_entry() then
                      cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                    else
                      fallback()
                    end
                  end,
                  s = cmp.mapping.confirm({ select = true }),
                  c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
                })
              '';

            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";

            "<Tab>" =
              # Lua
              ''
                cmp.mapping(function(fallback)
                  local luasnip = require('luasnip')
                  if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                  elseif cmp.visible() then
                    cmp.confirm({ select = true })
                  else
                    fallback()
                  end
                end, {'i', 's'})
              '';

            "<S-Tab>" =
              # Lua
              ''
                cmp.mapping(function(fallback)
                  local luasnip = require('luasnip')
                  if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                  else
                    fallback()
                  end
                end, {'i', 's'})
              '';
          };
        };
      };
    };

    extraConfigLua = ''
      require("luasnip.loaders.from_vscode").lazy_load()
    '';

    # keymaps = [
    #   {
    #     mode = ["i" "s"];
    #     key = "<Tab>";
    #     action.__raw = ''
    #       function()
    #         local luasnip = require("luasnip")
    #         if luasnip.expand_or_jumpable() then
    #           luasnip.expand_or_jump()
    #         else
    #           vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
    #         end
    #       end
    #     '';
    #     options = {
    #       silent = true;
    #       desc = "LuaSnip: Expand or jump forward";
    #     };
    #   }
    #   {
    #     mode = ["i" "s"];
    #     key = "<S-Tab>";
    #     action.__raw = ''
    #       function()
    #         local luasnip = require("luasnip")
    #         if luasnip.jumpable(-1) then
    #           luasnip.jump(-1)
    #         else
    #           vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", false)
    #         end
    #       end
    #     '';
    #     options = {
    #       silent = true;
    #       desc = "LuaSnip: Jump backward";
    #     };
    #   }
    # ];

    # blink-cmp = {
    #   enable = true;
    #   autoLoad = true;
    #   settings.windows.documentation.auto_show = true;
    #   settings.keymap.preset = "super-tab";
    #   settings.sources = {
    #     copilot = {
    #       async = true;
    #       module = "blink-cmp-copilot";
    #       name = "copilot";
    #       score_offset = 100;
    #       transform_items = {
    #         __raw = ''
    #           function(_, items)
    #           	local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
    #           	local kind_idx = #CompletionItemKind + 1
    #           	CompletionItemKind[kind_idx] = "Copilot"
    #           	for _, item in ipairs(items) do
    #           		item.kind = kind_idx
    #           	end
    #           	return items
    #           end
    #         '';
    #       };
    #     };
    #   };
    #   settings.sources.default = [
    #     "lsp"
    #     "path"
    #     "snippets"
    #     "buffer"
    #     "copilot"
    #   ];
    #   settings.completion = {
    #     keyword = {range = "prefix";}; # full looks ahead for fuzzy matching
    #     ghost_text = {enabled = true;};
    #     menu = {
    #       border = "single";
    #       draw = {
    #         columns = [
    #           [
    #             "label"
    #             "label_description"
    #             {gap = 1;}
    #           ]
    #           [
    #             "kind_icon"
    #             {gap = 1;}
    #             "kind"
    #           ]
    #         ];
    #       };
    #     };
    #   };
    # };
  };
}
