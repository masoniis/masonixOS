{
  config,
  pkgs,
  lib,
  ...
}:
let
  runtimeLibs = with pkgs; [
    # The key package that provides libstdc++.so.6
    stdenv.cc.cc.lib
  ];
in
{
  config = lib.mkIf config.language.python.enable {
    home.packages = with pkgs; [
      uv
      python312 # necessary in addition to uv because nix must manage the executables
    ];

    ldLibraryPathParts = [ (lib.makeLibraryPath runtimeLibs) ];
  };
}
