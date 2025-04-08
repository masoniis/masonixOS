{
  config,
  pkgs,
  lib,
  ...
}:
let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  unsupported = builtins.abort "Unsupported platform";
in
{
  home.username = "mason";
  home.stateVersion = "23.11"; # WARNING: read docs before updating

  home.homeDirectory =
    if isLinux then
      "/home/mason"
    else if isDarwin then
      "/Users/mason"
    else
      unsupported;

  home.shellAliases = {
    hm = "home-manager";
    # hmswitch = "home-manager switch --flake ${config.flakePath}";
    # nrswitch = "sudo nixos-rebuild switch --flake ${config.flakePath}";
  };

  programs.home-manager.enable = true; # Let home manager manage itself

  # INFO: If home-manager is not isolated then home-manager is not in the path,
  # we need to add home-manager to the path by installing the package
  # home.packages = [
  #   (lib.mkIf (!config.homeManagerOnly) pkgs.home-manager)
  # ];

  # Add nix only on home-manager isolated systems since nixos has it in default module
  # nix = lib.mkIf config.homeManagerIsolated {
  #   package = pkgs.nixVersions.latest;
  #   settings = {
  #     experimental-features = [
  #       "nix-command"
  #       "flakes"
  #     ];
  #     auto-optimise-store = true;
  #   };
  #   gc = {
  #     automatic = true;
  #     frequency = "weekly";
  #     options = "--delete-older-than 30d";
  #   };
  # };
}
