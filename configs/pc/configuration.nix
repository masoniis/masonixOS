{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Use your module that you made in the modules/ folder
  my-module.enable = true;

  # You can generate the configuration.nix and hardware-configuration.nix for
  # your system by using the following command:
  #
  # nixos-generate-config --dir configs/pc
  #
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.john.isNormalUser = true;
}
