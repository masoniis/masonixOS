{
  description = "Minimal project template with devShell and treefmt";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    masonpkgs.url = "github:masoniis/masonixOS";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    masonpkgs.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      masonpkgs,
      treefmt-nix,
    }:
    let
      eachSystem = nixpkgs.lib.genAttrs (import systems);
      treefmtEval = eachSystem (
        system: treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix
      );
    in
    {
      # standard formatter output
      formatter = eachSystem (system: treefmtEval.${system}.config.build.wrapper);

      # development shell
      devShells = eachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          mpkgs = masonpkgs.packages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # add your core tools here
              just
              uv
              treefmtEval.${system}.config.build.wrapper
              mpkgs.run-in-roblox
            ];

            shellHook = ''
              echo "Modular Dev Environment Loaded"
            '';
          };
        }
      );

      # optional: CI checks
      checks = eachSystem (system: {
        formatting = treefmtEval.${system}.config.build.check self;
      });
    };
}
