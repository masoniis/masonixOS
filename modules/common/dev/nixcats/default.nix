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
    luaPath = root + /dotfiles/nvim;

    packageNames = [ "myNvim" ];

    # Defines the "myNvim" package.
    packageDefinitions.replace = {
      myNvim =
        { pkgs, ... }:
        {
          settings = {
            # This creates shell aliases for your nvim command.
            aliases = [
              "vim"
              "vi"
              "n"
              "nv"
              "nvi"
              "nvim"
            ];
          };
          # Even an empty set is enough to build a default Neovim.
          categories = {
            categories = {
              general = true;
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
      }@packageDef:
      {
        startupPlugins = {
          general = with pkgs.vimPlugins; [
            alpha-nvim
            which-key-nvim
          ];
        };

        optionalPlugins = {
        };
      }
    );
  };
}
