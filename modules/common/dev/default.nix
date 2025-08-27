{ ... }:
{
  imports = [
    ./termshell.nix
    ./direnv.nix
    ./git.nix
    ./ai.nix

    ./languages
    ./nixcats
  ];
}
