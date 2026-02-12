{ ... }:
{
  imports = [
    ./termshell.nix
    ./devenvs.nix
    ./git.nix
    ./ai.nix

    ./languages
    ./nixcats
  ];
}
