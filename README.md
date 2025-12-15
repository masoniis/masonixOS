# masonixOS

A flake that is expanding to encompass all dotfiles and system configs across linux/darwin hosts including wsl.

## Philosophy

The ultimate goal is to manage the entire system with a flake, but also have the flake be agnostic to the system type. In other words, the flake should work on NixOS, MacOS/darwin, regular linux distros, and WSL (whether nixos or other).

- For NixOS based and nix-darwin, we will use the `nixos` module system to configure the system as well as home-manager for packages
- For non-nixos or nix-darwin, we will use only the `home-manager` modules to configure the system packages

## Sections information

- `nixos/` includes direct nixos configurations
- `hosts/` includes host setups that call modules and home-manager configurations based on the host
- `custompkgs/` includes my own custom derivations for things that aren't in nixpkgs
- `config/` includes dotfiles that are managed through nixos configuration directly

## Using the flake

You can build a specific host with

- `sudo nixos-rebuild switch --flake .#hostname` for nixos isolated config
- `sudo nixos-rebuild switch --flake .#user@hostname` for nixos configs + home-manager
- `home-manager switch --flake .#user@hostname` for just home-manager packages

The `flake.nix` defines all of the configurations and what modules they call.

### Secrets

Some parts of the flake assume access to files that are suffixed with `.key`. These assume you have been given access via `git-crypt`.

To add a new device

1. Generate a gpg key
2. Give the public key to the device
3. git-crypt add-gpg-user YOUR_GPG_KEY_ID

Then on new device, close and `git-crypt unlock`
