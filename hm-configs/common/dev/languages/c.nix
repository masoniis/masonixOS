{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.language.c.enable {
    home.packages = with pkgs; [
      clang
      clang-tools # clangd
    ];
  };
}
