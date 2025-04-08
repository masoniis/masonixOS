{
  pkgs,
  lib,
  ...
}:
{
  options.isDarwin = lib.mkEnableOption "is platform darwin?" // {
    default = pkgs.stdenv.hostPlatform.isDarwin;
  };
  options.isLinux = lib.mkEnableOption "is platform linux?" // {
    default = pkgs.stdenv.hostPlatform.isLinux;
  };

  imports = [
    # All dev essentials
    ./dev/default.nix

    # All system specific pkgs
    ./system/default.nix

    # Personal packages for random stuff
    ./personal/default.nix
  ];
}
