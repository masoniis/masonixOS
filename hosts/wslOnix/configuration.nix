# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{ pkgs, ... }:
{
  # WARNING: Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  users.users.mason = {
    ignoreShellProgramCheck = true; # shell is defined via home-manager
    shell = pkgs.zsh;
    openssh.authorizedKeys = {
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTbAHXhrIZzJXvOge68KHYVx88pvb0nlaz8tbFaPnho" # mason@xps
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZblT7Q/WxYTQnb3WL9lJMclp1DeQeYzdBKOBPAX0bD" # mason@masonmac
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILqYhMkfTYA7biVs4xp0OxhcV0Zk4yxvMTLn7u6S0PWc" # mason@[nixless windows 3080pc]
      ];
    };
  };

  # INFO: WSL STUFF
  wsl.enable = true;
  wsl.defaultUser = "mason";

  wsl.wslConf = {
    # not supported in wsl.conf, only the global .wslconfig which nix cannot provide 6/6/2025
    # wsl2 = {
    #   networkingMode = "mirrored";
    # };

    network = {
      hostname = "wslOnix"; # duped with nix, not sure if nix or wsl takes prio
      generateResolvConf = false;
    };
  };

  # important on WSL so that nvidia-smi & drivers in /usr/lib/wsl/lib can link properly
  programs.nix-ld.enable = true;

  # prevents nrswitch from failing on WSL despite network usually working
  systemd.services.NetworkManager-wait-online.enable = false;

  # open up remote desktop to connect from windows
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-x11";
    openFirewall = true;
    port = 3390; # windows likes to use the default port 3389 for rdp stuff in their apps (ie windows app)
    # if on networking mirrored, can simply use windows rdp to connect to localhost:3390
  };

  # INFO: Networking stuff
  networking = {
    hostName = "wslOnix";
    networkmanager.enable = true;
    nameservers = [
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
    };
  };

  # INFO: Other
  services.code-server = {
    enable = true;
    user = "mason";
    # hint: the password is `1234` 😈
    hashedPassword = "$argon2i$v=19$m=4096,t=3,p=1$c1hXbkhFNG8rUlg3aVBnOHVEZENXVmk1WlVzPQ$D1rr2WNl75cnpti+q/PkpTHNXGD+ENSktp2m+nMr2Vw";
  };
}
