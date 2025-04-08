{ config, lib, ... }:

let
  cfg = config.my-module;
in

{
  options.my-module.enable = lib.mkEnableOption "my module";

  config = lib.mkIf cfg.enable {

    # Write some Nix configuration for your module here

  };
}
