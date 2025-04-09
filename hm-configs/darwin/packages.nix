{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ollama # run local ml models
    iina # sleek video player (MPV replacement)
    zotero # reference manager

    # TODO: Migrate these to nix
    # raycast
    # arc
  ];
}
