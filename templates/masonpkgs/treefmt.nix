{
  projectRootFile = "flake.nix";
  programs = {
    # nix formatting
    nixfmt.enable = true;
    deadnix.enable = true;
    # general formatting (markdown, yaml, json, etc)
    prettier.enable = true;
    # project formatting
    ruff.enable = true; # python
  };
}
