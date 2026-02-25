# nixos-help to open nixos manual for information on options
{ pkgs, ... }:
{
  # WARNING: Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Time zone and internationalization settings
  time.timeZone = "America/Denver";
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment and wayland as display manager
  services.desktopManager.plasma6.enable = true;
  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
    defaultSession = "plasma";
  };
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Configure keymap in X11
  services.xserver = {
    xkb.variant = "";
    xkb.layout = "us";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.zsh;
  users.users.mason = {
    isNormalUser = true;
    description = "mason";
    openssh.authorizedKeys = {
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkXARiuSNUpCWhhRtp35ldIeg0T/2J6vaCr4CzUBeoz" # mason@wslOnix
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZblT7Q/WxYTQnb3WL9lJMclp1DeQeYzdBKOBPAX0bD" # mason@masonmac
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILqYhMkfTYA7biVs4xp0OxhcV0Zk4yxvMTLn7u6S0PWc" # mason@[nixless windows 3080pc]
      ];
    };
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # INFO: Remote control
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
    };
  };

  services.xrdp = {
    enable = true;
    defaultWindowManager = "startplasma-x11";
  };

  # INFO: Networking
  networking.networkmanager.enable = true;
  networking.hostName = "xpsOnix";

  services.pcscd.enable = true; # networking.firewall.enable = false;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt; # qt for plasma5
  };

  services.vnstat.enable = true;

  # broadcast hostname to local network
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  # INFO: Secrets setup
  sops.defaultSopsFile = ../../secrets/default.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # writes secrets to /run/secrets/...
  sops.secrets = {
    "personalEmail" = { }; # uses defaults
    "wgQuickConfiguration" = {
      sopsFile = ../../secrets/nordConfig.yaml;
    };
  };
}
