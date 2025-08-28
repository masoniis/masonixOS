{ root, ... }:
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
            necessary = true;
            lua.enable = true;
            java.enable = true;
            markdown.enable = true;
            python.enable = true;
            general = true;

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

          general = [
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
            catppuccin-nvim
            conform-nvim
            fidget-nvim
            gitsigns-nvim
            nvim-dap-ui
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
