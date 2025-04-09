{ lib, pkgs, ... }:
lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) {
  options.test.enable = lib.mkEnableOption "enable test hello module" // {
    default = false;
  };

  imports =
    [
      ./packages.nix
      ./rofi.nix
    ]
    ++ [
      #INFO: Specified shared configs
      ../common/default.nix # In this case, take everything from shared
    ];
}
