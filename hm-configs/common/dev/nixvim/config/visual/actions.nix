{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "actions-preview";
        src = pkgs.fetchFromGitHub {
          owner = "aznhe21";
          repo = "actions-preview.nvim";
          rev = "4ab7842eb6a5b6d2b004f8234dcf33382a0fdde2";
          sha256 = "MP1hohDL2JFembwW+cb2S+v2Y7j0iZw1jPPKTZiNCWI=";
        };
      })
    ];

    extraConfigLua = ''
      require("actions-preview").setup({
        snacks = {
          layout = { preset = "default" },
        },
      })
    '';
  };
}
