{ inputs, ... }:
let
  utils = import ../hostUtils.nix { inherit inputs; };
in
utils.nixosHomeManagerSystem {
  system = "x86_64-linux";
  username = "mason";
  extraModules = [
    ./media
    ./configuration.nix
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.dell-xps-15-7590-nvidia
    inputs.nixarr.nixosModules.default
  ];
  config = {
    personal.enable = true;
    entertainment.enable = true;
    language = {
      python.enable = true;
    };
  };
}
