{
  description = "doomsday nix configuration";

  inputs = {
    # Stable branch flakes
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    spicetify.url = "github:Gerg-L/spicetify-nix";

    # Other flakes
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    systems.url = "github:nix-systems/default";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    # Following
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
        wslOnix = import ./hosts/wslOnix { inherit inputs; };
        xpsOnix = import ./hosts/xpsOnix { inherit inputs; };
      };

      # To load a home-manager config isolated from the nixos config, these can be used.
      # home-manager switch --flake .#user@hostname
      # TODO: error on home-manager news evoked when using these. Same as:
      # https://discourse.nixos.org/t/news-json-output-and-home-activationpackage-in-home-manager-switch/54192
      packages.x86_64-linux.homeConfigurations = {
        "mason@wslOnix" = nixosConfigurations.wslOnix.config.home-manager.users."mason".home;
        "mason@xpsOnix" = nixosConfigurations.xpsOnix.config.home-manager.users."mason".home;
      };

      # Config for aarch-darwin based home-manager configs used currently on macbook
      # home-manager switch --flake .#user@hostname
      packages.aarch64-darwin.homeConfigurations = {
        mason = import ./hosts/masonmac { inherit inputs; };
      };
    }
    // (
      with inputs;
      let
        # Small tool to iterate over each systems
        eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});

        # Eval the treefmt modules from ./treefmt.nix
        treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
      in
      {
        # for `nix fmt`
        formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
        # for `nix flake check`
        checks = eachSystem (pkgs: {
          formatting = treefmtEval.${pkgs.system}.config.build.check self;
        });
      }
    );
}
