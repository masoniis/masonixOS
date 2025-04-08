{ ... }:
{
  imports = [
    ./termshell.nix
    ./direnv.nix
    ./git.nix

    ./languages
    ./nixvim
  ];
}
