{ pkgs, pkgs-unstable, ... }:
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
    # productivity
    pkgs.obsidian
    pkgs.zotero

    # ai stuff
    pkgs.subplz-mac
    pkgs-unstable.antigravity-cli
    pkgs-unstable.codex
    pkgs-unstable.opencode
  ];
}
