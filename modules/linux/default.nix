{ lib, config, ... }:
{
  options.test.enable = lib.mkEnableOption "enable test hello module" // {
    default = false;
  };

  imports = [
    ./packages.nix
    ./rofi.nix
    ./test.nix
  ]
  ++ [
    #INFO: Specified shared configs
    ../common/default.nix # In this case, take everything from shared
  ];
}
