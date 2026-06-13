{ pkgs, ... }:
{
  # allow unfree stuff
  nixpkgs.config.allowUnfree = true;

  # enable signing for just this device
  programs.git = {
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
      format = "ssh";
    };
  };

  # special host packages
  home.packages = [
    pkgs.obsidian
    pkgs.zotero
    pkgs.subplz-mac
  ];
}
