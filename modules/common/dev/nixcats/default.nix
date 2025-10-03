{ pkgs-unstable, ... }:
let
  binds = import ./binds.nix;
in
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
            zig.enable = true;

            # INFO: ----------------
            #    Config variables
            # ----------------------
            binds = binds;
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
        settings,
        categories,
        extra,
        name,
        mkPlugin,
        ...
      }:
      {
        lspsAndRuntimeDeps = with pkgs; {
          # INFO: ----------------
          #    Broad categories
          # ----------------------
          general = [
            nodejs-slim # required for copilot
            codespell
            ripgrep
            fd
          ];

          # INFO: -------------------
          #    Language categories
          # -------------------------
          clang = [
            clang-tools # includes clangd langserver
          ];

          glsl = [
            glsl_analyzer
          ];

          java = [
            jdt-language-server
            google-java-format
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

          markup = [
            prettierd
            taplo # toml formatter
          ];

          nix = [
            nixfmt-rfc-style
            nixd
          ];

          python = [
            basedpyright
            ruff
          ];

          rust = [
            rustfmt
            cargo
            rust-analyzer
            wgsl-analyzer # provides wgslfmt
          ];

          shell = [
            shfmt
            shellcheck
          ];

          zig = [
            zls # zig langserver
          ];

        };

        # Even though every plugin is a "startup plugin",
        # lazy-nvim manages the lazy loading of them.
        startupPlugins = {
          # INFO: ----------------
          #    Broad categories
          # ----------------------
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
            floaterm-masonpkgs
            gitsigns-nvim
            inc-rename-nvim
            neo-tree-nvim
            neotree-nesting-config-masonpkgs
            noice-nvim
            pkgs-unstable.vimPlugins.nui-nvim # unstable fixes an annoying deprecation warning 8/28/25
            tint-nvim
            todo-comments-nvim
            nvim-dap-ui
            nvim-treesitter.withAllGrammars
            nvzone-minty
            persistence-nvim
            slimline-masonpkgs
            smart-splits-nvim
            snacks-nvim
            oil-nvim
            render-markdown-nvim
            todo-comments-nvim
            toggleterm-nvim
            which-key-nvim
          ];

          # All necessary baseline plugins
          necessary = with pkgs.vimPlugins; [
            lazy-nvim

            # Common dependencies
            friendly-snippets
            nvim-web-devicons
            nvim-lspconfig
            plenary-nvim
          ];

          # INFO: -------------------
          #    Language categories
          # -------------------------
          java = with pkgs.vimPlugins; [
            nvim-jdtls
          ];

          lua = with pkgs.vimPlugins; [
            lazydev-nvim
          ];

          python = with pkgs.vimPlugins; [
            nvim-dap-python
          ];
        };
      }
    );
  };
}
