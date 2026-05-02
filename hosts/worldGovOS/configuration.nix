{ lib, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix
  ];

  # enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # mount drives
  fileSystems."/mnt/sdb1" = {
    device = "/dev/disk/by-uuid/25927064-e74e-4554-9930-faafd0eb91c6";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime" # without this, all reads count as writes
    ];
  };

  fileSystems."/data/media" = {
    fsType = "fuse.mergerfs";
    device = "/mnt/sdb1";
    options = [
      "defaults"
      "allow_other" # Essential: allows non-root users to access the mount
      "minfreespace=50G" # Don't write to a drive if it has less than 50G left
      "category.create=mfs" # "Most Free Space": write new files to the emptiest drive
      "fsname=mergerfs" # Makes "df -h" show a pretty name instead of a long device string
    ];
    depends = [ "/mnt/sdb1" ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "worldgov"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    mergerfs
  ];

  programs.git = {
    enable = true;
    config = {
      safe = {
        directory = "/etc/nixos/masonixOS";
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  # Enable Cockpit (Dashboard + Web Terminal)
  services.cockpit = {
    enable = true;
    openFirewall = true;
    port = 9090;
    settings = {
      WebService = {
        AllowUnencrypted = true;
        Origins = lib.mkForce "http://192.168.68.69:9090 http://127.0.0.1:9090";
      };
    };
  };

  system.stateVersion = "23.11"; # WARNING: dont update without reading docs

  # INFO: Secrets setup
  sops.defaultSopsFile = ../../secrets/worldgov.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # writes secrets to /run/secrets/...
  sops.secrets = {
    "wgQuickConfiguration" = {
      sopsFile = ../../secrets/worldgov.yaml;
    };
  };
}
