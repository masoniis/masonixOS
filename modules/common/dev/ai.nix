{ pkgs-unstable, ... }:
{
  home.packages = [
    pkgs-unstable.gemini-cli
    pkgs-unstable.claude-code
    pkgs-unstable.codex
    # pkgs.entire-masonpkgs
  ];
}
