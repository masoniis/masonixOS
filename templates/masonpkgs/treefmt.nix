{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs = {
    # nix formatting
    nixfmt = {
      enable = true;
      package = pkgs.nixfmt;
    };
    deadnix.enable = true;

    # general formatting (markdown, yaml, json, etc)
    prettier.enable = true;
    just.enable = true;
  };

  settings.global.excludes = [
    ".envrc"
  ];
}
