{
  lib,
  pkgs,
  config,
  ...
}:
{
  # TODO: Cop the zen browser instead of regular firefox when it's merged into nixpkgs:
  # https://github.com/NixOS/nixpkgs/pull/347222
  home.packages = [
    pkgs.wl-clipboard # Clipboard manager
    pkgs.clang
    pkgs.firefox
  ] ++ lib.optional config.test.enable pkgs.hello;
}
