{
  lib,
  pkgs,
  config,
  ...
}:
{
  home.packages = [
    pkgs.wl-clipboard # Clipboard manager
    pkgs.clang
    pkgs.firefox
  ]
  ++ lib.optional config.test.enable pkgs.hello;
}
