{ pkgs-unstable, ... }:
# let
#   utils = import inputs.nixCats;
# in
{
  nixCats = {
    enable = true;
    luaPath = ./nvim;

    packageNames = [ "myNvim" ];
    packageDefinitions.replace = {
      myNvim =
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

          # Determines which plugin categories (defined below) to enable
          categories = {
            necessary = true;
            lua.enable = true;
            java.enable = true;
            general = true;
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
          lua = [
            lua-language-server
            stylua
          ];

          java = [
            jdt-language-server
          ];

          general = [
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
            nvim-web-devicons
            nvim-lspconfig
            plenary-nvim
          ];

          lua = with pkgs.vimPlugins; [
            lazydev-nvim
          ];

          # General use plugins
          general = with pkgs.vimPlugins; [
            barbar-nvim
            catppuccin-nvim
            fidget-nvim
            gitsigns-nvim
            neo-tree-nvim
            snacks-nvim
            todo-comments-nvim
            which-key-nvim
          ];
        };
      }
    );
  };
}
