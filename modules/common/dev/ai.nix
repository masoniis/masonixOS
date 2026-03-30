{ pkgs-unstable, pkgs, ... }:
{
  home.packages = [
    pkgs-unstable.gemini-cli
    pkgs-unstable.claude-code
    # pkgs.entire-masonpkgs
  ];
}
