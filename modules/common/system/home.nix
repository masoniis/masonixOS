{
  username,
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
  home.username = username;
  home.stateVersion = "23.11"; # WARNING: read docs before updating
  news.display = "silent";

  home.homeDirectory =
    if isLinux then
      "/home/${username}"
    else if isDarwin then
      "/Users/${username}"
    else
      unsupported;

  home.shellAliases = {
    hm = "home-manager";
    hmswitch = "home-manager switch --flake ${config.flakePath}";
    nrswitch = "sudo nixos-rebuild switch --flake ${config.flakePath}";
  };

  programs.home-manager.enable = true; # Let home manager manage itself

  # INFO: ssh
  services.ssh-agent.enable = !isDarwin;
  programs.ssh = {
    # ssh-add -l to see loaded keys
    # enabling the ssh-agent informs some software of active keys
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      xps = {
        hostname = "bop.tplinkdns.com";
        user = "mason";
        port = 22;
        localForwards = [
          # open port 9091 to localhost for accessing transmission
          {
            bind.port = 9091;
            host.address = "localhost";
            host.port = 9091;
          }
        ];
      };
      worldgov = {
        hostname = "bop.tplinkdns.com";
        user = "mason";
        port = 23;
      };
    };
  };

  # INFO: If home-manager is not isolated then home-manager is not in the path,
  # we need to add home-manager to the path by installing the package
  home.packages = [
    (lib.mkIf (!config.homeManagerIsolated) pkgs.home-manager)
  ];

  # Add nix only on home-manager isolated systems since nixos has it in default module
  nix = lib.mkIf config.homeManagerIsolated {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # auto-optimise-store = false; # will cause errors on mac sadly
    };
    gc = {
      automatic = true;
      frequency = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
