{ pkgs, ... }:
{
  projectRootFile = "flake.nix";
  programs = {
    nixfmt.enable = true;
    nixfmt.package = pkgs.nixfmt-rfc-style;
    stylua.enable = true;
    prettier.enable = true;
    prettier.package = if pkgs ? prettier then pkgs.prettier else pkgs.nodePackages.prettier;
  };
}
