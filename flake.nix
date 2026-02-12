{
  description = "doomsday nix configuration";

  inputs = {
    # Stable branch flakes
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    spicetify.url = "github:Gerg-L/spicetify-nix";

    # Other flakes
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    systems.url = "github:nix-systems/default";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    sops-nix.url = "github:Mic92/sops-nix";
    nixarr.url = "github:rasmus-kirk/nixarr";

    # Following
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    spicetify.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs =
    { ... }@inputs:
    rec {
      # To load a nixos config with home-manager built into it run
      # sudo nixos-rebuild switch --flake .#hostname
      nixosConfigurations = {
        worldgov = import ./hosts/worldGovOS { inherit inputs; };
        wslOnix = import ./hosts/wslOnix { inherit inputs; };
        xpsOnix = import ./hosts/xpsOnix { inherit inputs; };
      };

      # To load a home-manager config isolated from the nixos config, these can be used.
      # home-manager switch --flake .#user@hostname
      # TODO: error on home-manager news evoked when using these. Same as:
      # https://discourse.nixos.org/t/news-json-output-and-home-activationpackage-in-home-manager-switch/54192
      packages.x86_64-linux.homeConfigurations = {
        "mason@worldgov" = import ./hosts/masongov { inherit inputs; };
        "mason@wslOnix" = nixosConfigurations.wslOnix.config.home-manager.users."mason".home;
        "mason@xpsOnix" = nixosConfigurations.xpsOnix.config.home-manager.users."mason".home;
      };

      # Config for aarch-darwin based home-manager configs used currently on macbook
      # home-manager switch --flake .#user@hostname
      packages.aarch64-darwin.homeConfigurations = {
        mason = import ./hosts/masonmac { inherit inputs; };
      };
    }
    # system dependent config in this merge block
    // (
      with inputs;
      let
        # iter each system
        eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});

        # eval the treefmt modules from ./treefmt.nix
        treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
      in
      {
        # for `nix fmt`
        formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
        # for `nix flake check`
        checks = eachSystem (pkgs: {
          formatting = treefmtEval.${pkgs.system}.config.build.check self;
        });

        devShells = eachSystem (pkgs: {
          default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              sops
              ssh-to-age
            ];

            # automatically load sops key when in dev shell
            shellHook = ''
              export SOPS_AGE_KEY=$(ssh-to-age -private-key -i ~/.ssh/id_ed25519)
              printf "User SOPS public age key: $(ssh-to-age -i ~/.ssh/id_ed25519.pub)\n"
              if [ -r /etc/ssh/ssh_host_ed25519_key.pub ]; then
              	printf "Host SOPS public age key: $(cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age)\n"
              else
              	printf "Host SOPS public age key: Can't be read (File missing or permission denied)\n"
              fi
            '';
          };
        });
      }
    );
}
