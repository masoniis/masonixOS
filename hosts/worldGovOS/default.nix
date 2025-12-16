{ inputs, ... }:
let
  utils = import ../hostUtils.nix { inherit inputs; };
in
utils.nixosSystem {
  system = "x86_64-linux";
  extraModules = [
    ./media
    ./minecraft.nix
    ./configuration.nix
    inputs.nixarr.nixosModules.default
  ];
  config = {
    # hhhhhh no config :(
  };
}
