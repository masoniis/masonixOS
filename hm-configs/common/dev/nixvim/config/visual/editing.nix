# related to the visual editing experience!
{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      illuminate.enable = true;
      todo-comments.enable = true;
      # intellitab = {
      #   enable = true;
      #   # TODO: remove custom intellitab package once upstream accepts pr
      #   package = pkgs.vimUtils.buildVimPlugin {
      #     name = "intellitab";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "simondoesstuff";
      #       repo = "intellitab.nvim";
      #       rev = "fad06f80b44186767eba348283c3b88827a969b1";
      #       sha256 = "sha256-ShMECcqFQS607ZWRKHEh1cSLT/XChx5JpNOHSP3h/7I=";
      #     };
      #   };
      # };
      nvim-ufo.enable = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "zR";
        action.__raw = "function() require('ufo').openAllFolds() end";
        options = {
          silent = true;
          desc = "open all folds";
        };
      }
      {
        mode = "n";
        key = "zM";
        action.__raw = "function() require('ufo').closeAllFolds() end";
        options = {
          silent = true;
          desc = "close all folds";
        };
      }
    ];
  };
}
