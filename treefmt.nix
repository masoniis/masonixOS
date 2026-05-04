{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs = {
    # nix formatting
    nixfmt = {
      enable = true;
      package = pkgs.nixfmt-rfc-style;
    };

    # general formatting (markdown, yaml, json, etc)
    prettier = {
      enable = true;
      package = pkgs.nodePackages.prettier;
    };

    # project formatting
    stylua.enable = true;
  };
}
