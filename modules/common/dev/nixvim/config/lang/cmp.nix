{ config, ... }:
let
  listToUnkeyedAttrs = config.lib.nixvim.listToUnkeyedAttrs;
in
{
  programs.nixvim = {
    plugins = {
      colorful-menu.enable = true;
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

      blink-cmp = {
        enable = true;
        autoLoad = true;
        # TODO: Setup ghost text for suggestions, (ESPECIALLY COPILOT)
        # also needs ability to toggle the menu so you can see multi-line ghost text easily
        settings = {
          keymap.preset = "super-tab"; # vscode-like
          snippets = {
            preset = "luasnip";
          };
          sources.default = [
            # "copilot" not set up yet, TODO, but we still want ghost text
            "snippets"
            "lsp"
            "path"
            "buffer"
          ];
          appearance = {
            nerd_font_variant = "normal";
            use_nvim_cmp_as_default = true;
          };
          completion.menu.draw = {
            columns = [
              [
                "kind_icon"
                "kind"
              ]
              (
                (listToUnkeyedAttrs [
                  "label"
                  "label_description"
                ])
                // {
                  gap = 1;
                }
              )
            ];
            components = {
              label = {
                text.__raw = ''
                  function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                  end
                '';
                highlight.__raw = ''
                  function(ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
                  end
                '';
              };
            };
          };
        };
      };
    };

    extraConfigLua = ''
      require("luasnip.loaders.from_vscode").lazy_load()
    '';
  };
}
