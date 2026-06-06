{ inputs, ... }:
let
  utils = import ../hostUtils.nix { inherit inputs; };
in
utils.nixosHomeManagerSystem {
  system = "x86_64-linux";
  username = "mason";
  extraNixosModules = [
    ./nixos/configuration.nix
    ./nixos/hardware-configuration.nix
    ../../modules/linux/media-server
    inputs.nixos-hardware.nixosModules.dell-xps-15-7590-nvidia
    inputs.nixarr.nixosModules.default
  ];
  extraHomeModules = [
    ./home-manager/home.nix
  ];
  config = {
    personal.enable = true;
    entertainment.enable = true;
    language = {
      python.enable = true;
    };
    nvim.showBattery = true;
  };
}
