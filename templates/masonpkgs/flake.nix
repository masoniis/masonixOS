{
  description = "Minimal project template with devShell, treefmt, and masonpkgs";

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
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      # INFO: -------------------
      #         dev shell
      # -------------------------

      # for `nix develop` (or automatically via direnv)
      devShells = eachSystem (
        pkgs:
        let
          mpkgs = masonpkgs.packages.${pkgs.stdenv.hostPlatform.system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # core
              just

              # masonpkgs
              mpkgs.subplz

              # formatting (`treefmt` directly, same as `nix fmt`)
              treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper
            ];
          };
        }
      );

      # INFO: --------------------
      #         formatting
      # --------------------------

      # for `nix fmt`
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper);

      # for `nix flake check`
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.check self;
      });
    };
}
