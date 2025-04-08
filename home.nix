{ ... }:
{ }
# {
#   config,
#   pkgs,
#   ...
# }:
#
# let
#   inherit (pkgs) stdenv;
# in
# {
#   home.stateVersion = "24.05";
#
#   home.homeDirectory =
#     if stdenv.isDarwin then "/Users/${config.home.username}" else "/home/${config.home.username}";
#
#   programs.home-manager.enable = true;
# }
