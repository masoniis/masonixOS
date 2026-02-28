{ inputs }:
let
  inherit (inputs) nixpkgs home-manager sops-nix;

  # lil helper to allow unfree in all the unstables
  mkPkgsUnstable =
    system:
    import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

  # general special args for nixos systems
  mkSpecialArgs = system: {
    pkgs-unstable = mkPkgsUnstable system;
    inherit (inputs) self;
  };

  # general special args for home manager
  mkHomeManagerSpecialArgs = system: username: {
    pkgs-unstable = mkPkgsUnstable system;
    pkgs-spice = inputs.spicetify.legacyPackages.${system};
    root = inputs.self;
    inherit username;
  };
in
{
  # NixOS isolated setup with no assumptions on default user
  nixosSystem =
    {
      config,
      system,
      extraModules ? [ ],
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = mkSpecialArgs system;
      modules = [
        sops-nix.nixosModules.sops
        config
      ]
      ++ extraModules;
    };

  # NixOS + Homemanager personal PC setup
  nixosHomeManagerSystem =
    {
      config,
      system,
      username,
      extraModules ? [ ],
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = mkSpecialArgs system;
      modules = [
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          # home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.${username} =
            { ... }:
            {
              nixpkgs.overlays = [
                inputs.self.overlays.masonpkgs
              ];
              imports = [
                ../modules/linux/default.nix
                config
                inputs.nixCats.homeModule
                inputs.spicetify.homeManagerModules.spicetify
              ];
            };

          home-manager.extraSpecialArgs = mkHomeManagerSpecialArgs system username;
        }
      ]
      ++ extraModules;
    };

  # General home-manager configuration wrapper that takes in config system and username
  homeManagerSetup =
    {
      config,
      system,
      username,
    }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ inputs.self.overlays.masonpkgs ];
      };
      extraSpecialArgs = mkHomeManagerSpecialArgs system username;
      modules = [
        (
          if system == "aarch64-darwin" || system == "x86_64-darwin" then
            ../modules/darwin/default.nix
          else
            ../modules/linux/default.nix
        )
        inputs.nixCats.homeModule
        inputs.spicetify.homeManagerModules.spicetify
        config
        { homeManagerIsolated = true; }
      ];
    };
}
