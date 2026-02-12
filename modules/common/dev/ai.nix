{ pkgs-unstable, ... }:
{
  home.packages = [
    pkgs-unstable.gemini-cli
    pkgs-unstable.claude-code
  ];
}
