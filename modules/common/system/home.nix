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
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*".AddKeysToAgent = "yes";
      # update hostname of xps to local address if available
      "check-xps-local" = {
        header = "Match host xps exec \"${pkgs.coreutils}/bin/timeout 0.2 ${pkgs.netcat}/bin/nc -z 192.168.68.72 22\"";
        HostName = "192.168.68.72";
      };
      xps = {
        HostName = "bop.tplinkdns.com";
        User = "mason";
        Port = 22;
        LocalForward = [
          {
            bind.port = 9091;
            host.address = "localhost";
            host.port = 9091; # transmission port
          }
        ];
      };

      # update hostname of worldgov to local address if available
      "check-worldgov-local" = {
        header = "Match host worldgov exec \"${pkgs.coreutils}/bin/timeout 0.2 ${pkgs.netcat}/bin/nc -z 192.168.68.69 22\"";
        HostName = "192.168.68.69";
        Port = 22;
      };
      worldgov = {
        HostName = "bop.tplinkdns.com";
        User = "mason";
        Port = 23;
        LocalForward = [
          {
            bind.port = 9091;
            host.address = "localhost";
            host.port = 9091; # transmission port
          }
        ];
      };
    };
  };

  # INFO: If home-manager is not isolated then home-manager is not in the path,
  # we need to add home-manager to the path by installing the package
  home.packages = [ (lib.mkIf (!config.homeManagerIsolated) pkgs.home-manager) ];

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
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
