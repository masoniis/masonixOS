{ ... }:

{
  # You can generate the configuration.nix and hardware-configuration.nix for
  # your system by using the following command:
  #
  # nixos-generate-config --dir configs/pc

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c2a5816f-af17-4d9f-9b55-3c52100cc342";
    fsType = "ext4";
  };
}
