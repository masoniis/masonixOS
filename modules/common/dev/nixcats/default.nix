{
  config,
  pkgs,
  inputs,
  root,
  ...
}:
let
  utils = import inputs.nixCats;
in
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
        startupPlugins = {
          general = with pkgs.vimPlugins; [
            alpha-nvim
						catppuccin-nvim
						snacks-nvim
            which-key-nvim
          ];
        };

        optionalPlugins = {
          general = with pkgs.vimPlugins; [
						lazydev-nvim
          ];
        };
      }
    );
  };
}
