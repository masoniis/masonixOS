{ pkgs, lib, ... }:
{
  options.isDarwin = lib.mkEnableOption "is platform darwin?" // {
    default = pkgs.stdenv.hostPlatform.isDarwin;
  };
  options.isLinux = lib.mkEnableOption "is platform linux?" // {
    default = pkgs.stdenv.hostPlatform.isLinux;
  };

  # TODO: (becomes $LD_LIBRARY_PATH) not yet impl for osx, which is $DYLD_LIBRARY_PATH
  options.ldLibraryPathParts = lib.mkOption {
    type = with lib.types; listOf str;
    default = [ ];
    description = "A list of paths to be combined into the LD_LIBRARY_PATH environment variable.";
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
