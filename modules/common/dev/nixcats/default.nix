{
  pkgs-unstable,
  config,
  lib,
  ...
}:
{
  options.nvim = {
    showBattery = lib.mkEnableOption "Show battery in statusline?" // {
      default = false;
    };
    binds = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Keybinding overrides for Neovim (overrides defaults defined in binds.nix)";
    };
  };

  config.nixCats = {
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
            show_battery = config.nvim.showBattery;

            # INFO: -------------------
            #    Language categories
            # -------------------------
            clang.enable = true;
            glsl.enable = true;
            java.enable = true;
            lua.enable = true;
            markdown.enable = true;
            markup.enable = true;
            nix.enable = true;
            python.enable = true;
            rust.enable = true;
            shell.enable = true;
            web.enable = true;
            zig.enable = true;

            # INFO: ----------------
            #    Config variables
            # ----------------------
            binds = lib.recursiveUpdate (import ./binds.nix) config.nvim.binds;
            javaPaths = {
              java_debug_dir = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server";
              java_test_dir = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server";
              jdtls_executable = "${pkgs.jdt-language-server}/bin/jdtls";
            };
          };
        };
    };

    categoryDefinitions.replace = (
      {
        pkgs,
        ...
      }:
      {
        lspsAndRuntimeDeps = with pkgs; {
          # INFO: --------------------------
          #         broad categories
          # --------------------------------

          general = [
            nodejs-slim # required for copilot
            codespell
            ripgrep
            fd
          ];

          # INFO: -----------------------------
          #         language categories
          # -----------------------------------

          clang = [
            clang-tools # includes clangd langserver
          ];

          glsl = [ glsl_analyzer ];

          java = [
            jdt-language-server
            google-java-format
            vscode-extensions.vscjava.vscode-java-test
            vscode-extensions.vscjava.vscode-java-debug
          ];

          lua = [
            lua-language-server
            stylua
            selene
          ];

          markdown = [ prettierd ];

          markup = [
            prettierd
            taplo # toml formatter
          ];

          nix = [
            nixfmt
            nixd
          ];

          python = [
            basedpyright
            ruff
          ];

          rust = [
            pkgs-unstable.rustfmt
            pkgs-unstable.cargo
            pkgs-unstable.rust-analyzer
            pkgs-unstable.rustc # rustc is needed for some rust-analyzer features (*cough* procmacro)
            pkgs-unstable.wgsl-analyzer # provides wgslfmt
          ];

          shell = [
            shfmt
            shellcheck
          ];

          web = [
            typescript-language-server
            tailwindcss-language-server
          ];

          zig = [
            zls # zig langserver
          ];

        };

        # Even though every plugin is a "startup plugin",
        # lazy-nvim manages the lazy loading of them.
        startupPlugins = {
          # All necessary baseline plugins
          necessary = with pkgs.vimPlugins; [
            lazy-nvim

            # common dependencies
            friendly-snippets
            nvim-web-devicons
            nvim-lspconfig
            plenary-nvim
          ];

          # INFO: --------------------------
          #         broad categories
          # --------------------------------

          general = with pkgs.vimPlugins; [
            barbar-nvim
            battery-nvim-masonpkgs
            blink-cmp
            blink-copilot
            catppuccin-nvim
            conform-nvim
            colorful-menu-nvim
            copilot-lua
            fidget-nvim
            floaterm
            gitsigns-nvim
            inc-rename-nvim
            minuet-ai-nvim
            neotest
            neo-tree-nvim
            neotree-nesting-config-masonpkgs
            noice-nvim
            nvim-dap-ui
            nvim-treesitter.withAllGrammars
            nui-nvim
            nvzone-minty
            oil-nvim
            persistence-nvim
            slimline-masonpkgs
            render-markdown-nvim
            smart-splits-nvim
            snacks-nvim
            tint-nvim
            todo-comments-nvim
            todo-comments-nvim
            toggleterm-nvim
            which-key-nvim
          ];

          # INFO: -----------------------------
          #         language categories
          # -----------------------------------

          java = with pkgs.vimPlugins; [ nvim-jdtls ];

          lua = with pkgs.vimPlugins; [ lazydev-nvim ];

          python = with pkgs.vimPlugins; [ nvim-dap-python ];

          rust = with pkgs.vimPlugins; [
            rustaceanvim
          ];
        };
      }
    );
  };
}
