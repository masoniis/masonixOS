{ pkgs, ... }:
{
  users.users.simon = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      firefox
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDSzAG3Xgy9Sf0Ype3TolDXEtaBCtiUMyexxT1p67WbPOxR1/4qj4d3HgNezm+9Q+SSI4oYUofU552zdp5kUBdi19A3B5NWNEBmka/AGPEBer9UmbghgdtjzB+Fiqq6iBJAO4jnfaW29M7tlMMX6BgQHjgn5F3qblY4QKYD+d2e2LIJcbvTTIf91bFNhF4UUzfOMcXVIEmvrMhOB5ytKakoMrhFzFPPtQC7/R6fKd+Ua5yth9swp8Yp4OPbYXhm9mEhBtHyePUZQBvo7eq5if7VurCJ945PInnEgdR87YNpN6SvXLmSxmFtwABrCARzp0rYSmd71SX1PXHBvGdKp7y8pfsSv349j7+/n+qzF6dEPn7V0tvZa91+HHxxNukmhGS3UhPPX+481BvHi4HqjEA0Aj492gr/AfUIfcYkUkuztTvzbIumtOeTzkahT/sVSBVjTDpkkp4eP8ziKJjybO1yVeL+HnxF4Vr+4BOUnOecaJ52zeSOhG8MApFllnJGD9U= simon@EuclidMac.local" # euclidmac
    ];
  };

  users.users.mason = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIZblT7Q/WxYTQnb3WL9lJMclp1DeQeYzdBKOBPAX0bD" # mbp14 (mason)
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILqYhMkfTYA7biVs4xp0OxhcV0Zk4yxvMTLn7u6S0PWc" # windows 3080pc (mason)
    ];
  };

  users.users.brendan = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = [
    ];
  };
}
