{ inputs, ... }:
let
  inherit (inputs) nixos-wsl;
  utils = import ../hostUtils.nix { inherit inputs; };
in
utils.nixosHomeManagerSystem {
  system = "x86_64-linux";
  username = "mason";
  extraNixosModules = [
    # nixos-wsl necessary modules
    nixos-wsl.nixosModules.wsl
    # custom nixos configs
    ./nixos/configuration.nix
  ];
  extraHomeModules = [
    # custom hm configs
    ./home-manager/home.nix
  ];
  config = {
    personal.enable = true;
    language = {
      python.enable = true;
    };
  };
}
