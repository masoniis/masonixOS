{ inputs, ... }:
let
  inherit (inputs) nixos-wsl;
  utils = import ../hostUtils.nix { inherit inputs; };
in
utils.nixosHomeManagerSystem {
  system = "x86_64-linux";
  username = "mason";
  extraModules = [
    nixos-wsl.nixosModules.wsl # nixos-wsl necessary modules
    ./configuration.nix
  ];
  config = {
    personal.enable = true;
    language = {
      python.enable = true;
    };
  };
}
