{
  description = "a flake based on onix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    nixvim.url = "github:nix-community/nixvim/main";
    onix.url = "github:computerdane/onix/v0.1.2";

    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixvim,
      onix,
      ...
    }@inputs:
    onix.init {
      inherit nixpkgs home-manager;
      extraHomeManagerModules = [ inputs.nixvim.homeManagerModules.nixvim ];
      src = ./.;
    };
}
