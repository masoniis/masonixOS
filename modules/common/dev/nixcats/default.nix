{ pkgs-unstable, ... }:
{
  nixCats = {
    enable = true;
    luaPath = ./nvim;

    packageNames = [ "onixNvim" ];
    packageDefinitions.replace = {
      onixNvim =
        { pkgs, ... }:
        {
          settings = {
            aliases = [
              "vim"
              "vi"
              "n"
              "nv"
              "nvi"
              "nvim"
            ];
          };

          # Determines which plugin categories to enable
          categories = {
            # INFO: ----------------
            #    Broad categories
            # ----------------------
            necessary = true;
            general = true;

            # INFO: -------------------
            #    Language categories
            # -------------------------
            lua.enable = true;
            java.enable = true;
            markdown.enable = true;
            python.enable = true;
            zig.enable = true;
            glsl.enable = true;

            # INFO: ----------------
            #    Config variables
            # ----------------------
            javaPaths = {
              java_debug_dir = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server";
              java_test_dir = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server";
            };
          };
        };
    };

    categoryDefinitions.replace = (
      {
        pkgs,
        settings,
        categories,
        extra,
        name,
        mkPlugin,
        ...
      }:
      {
        lspsAndRuntimeDeps = with pkgs; {
          glsl = [
            glsl_analyzer
          ];

          java = [
            jdt-language-server
            vscode-extensions.vscjava.vscode-java-test
            vscode-extensions.vscjava.vscode-java-debug
          ];

          lua = [
            lua-language-server
            stylua
          ];

          markdown = [
            prettierd
          ];

          python = [
            basedpyright
            ruff
          ];

          zig = [
            zls # zig langserver
          ];

          general = [
            nodejs-slim # required for copilot
            prettierd # shell formatting, other general use
            ripgrep
            fd
          ];
        };

        # Even though every plugin is a "startup plugin",
        # lazy-nvim can manage the lazy loading of them.
        startupPlugins = {

          # All necessary baseline plugins
          necessary = with pkgs.vimPlugins; [
            lazy-nvim

            # Common dependencies
            friendly-snippets
            nvim-web-devicons
            nvim-lspconfig
            plenary-nvim
          ];

          java = with pkgs.vimPlugins; [
            nvim-jdtls
          ];

          lua = with pkgs.vimPlugins; [
            lazydev-nvim
          ];

          # General use plugins
          general = with pkgs.vimPlugins; [
            barbar-nvim
            blink-cmp
            blink-copilot
            catppuccin-nvim
            conform-nvim
            copilot-lua
            fidget-nvim
            gitsigns-nvim
            neo-tree-nvim
            neotree-nesting-config-nvim
            noice-nvim
            pkgs-unstable.vimPlugins.nui-nvim # unstable fixes an annoying deprecation warning 8/28/25
            nvim-dap-ui
            nvim-treesitter.withAllGrammars
            slimline-nvim
            smart-splits-nvim
            snacks-nvim
            todo-comments-nvim
            toggleterm-nvim
            which-key-nvim
          ];
        };
      }
    );
  };
}
