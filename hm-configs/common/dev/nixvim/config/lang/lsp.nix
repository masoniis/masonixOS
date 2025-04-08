{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      settings = {
        ensure_installed = "all";
        ignore_install = [ "norg" ];
        highlight = {
          enable = true;
          additional_vim_regex_highlighting = true;
        };
        incremental_selection.enable = true;
        indent.enable = true;
      };
    };

    plugins.lsp = {
      enable = true;
      servers = {
        lua_ls = {
          enable = true;
          settings = {
            Lua = {
              workspace = {
                # TODO: Fetch this using fetchgit
                library = [ "/Users/mason/dev/computercraft/ccls/library" ];
              };
            };
          };
        };

        # TODO: drip out nix language server setup
        # nixd.enable = true;
        nil_ls.enable = true;

        tailwindcss = {
          enable = true;
          # TODO: Need to create a cmd selection function.
          # If bunx exist, use that, otherwise node, etc
          cmd = [
            "bunx"
            "tailwindcss-language-server"
          ];
          extraOptions = {
            on_init = {
              __raw = ''
                function(client)
                  client.config.settings.tailwindCSS = {
                    experimental = { classRegex = { "class:?\\s*'([^']*)'" } }
                  }
                end
              '';
            };
          };
        };

        svelte = {
          enable = true;
          # cmd = ["svelteserver" "--stdio"];
        };

        ts_ls.enable = true;
        html.enable = true;
        cssls.enable = true;
        jsonls.enable = true;

        glsl_analyzer = {
          enable = true;
          filetypes = [
            "glsl"
            "vert"
            "tesc"
            "tese"
            "frag"
            "geom"
            "comp"
            "fsh"
            "vsh"
          ];
          extraOptions = {
            on_attach = {
              __raw = ''
                function(client, _)
                  client.cancel_request = function(_, _) end -- do nothing avoiding error message
                end
              '';
            };
          };
        };

        pylsp.enable = true;
        pylsp.settings = {
          plugins = {
            jedi_completion = {
              enabled = true;
            };
            pycodestyle = {
              enabled = true;
            };
            pylsp_rope = {
              enabled = true;
            };
            pylint = {
              enabled = true;
            };
          };
        };
        # jedi_language_server.enable = true;
        # dartls.enable = true; dont enable with flutter-tools
        clangd.enable = true;
        sourcekit.enable = true;
      };
    };

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "inc_rename";
        src = pkgs.fetchFromGitHub {
          owner = "smjonas";
          repo = "inc-rename.nvim";
          rev = "f9b9e5b9a75074810f40881b7e254b5bbeaf122e";
          sha256 = "7XaYG2UUzFuvtmRALftDv2xlmR4xHF/OjhoGTz0mnl4=";
        };
      })
    ];

    # Also add the autocommand for floating diagnostics
    extraConfigLua = builtins.readFile ./lsp.lua;
  };
}
