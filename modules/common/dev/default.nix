{ ... }:
{
  imports = [
    ./termshell.nix
    ./devenvs.nix
    ./git.nix

    ./languages
    ./nixcats
  ];
}
