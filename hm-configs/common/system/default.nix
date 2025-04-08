{ lib, ... }:
{
  options.homeManagerIsolated = lib.mkEnableOption "is home manager without nixOS?" // {
    default = false;
  };

  options.flakePath = lib.mkOption {
    type = lib.types.str;
    default = "~/.config/masonixOS";
    description = "Path to the flake used by some alias commands";
  };

  imports = [
    ./essentials.nix
    ./home.nix
  ];
}
