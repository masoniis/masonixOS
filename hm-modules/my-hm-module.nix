{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my-hm-module;
in

{
  options.my-hm-module.enable = lib.mkEnableOption "my home-manager module";

  config = lib.mkIf cfg.enable {

    home.packages = [ pkgs.lolcat ];

    # Write some Nix configuration for your module here

  };
}
