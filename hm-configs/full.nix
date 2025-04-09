# downloads full config for home manager based on system
{
  lib,
  ...
}:
{
  options.root = lib.mkOption {
    type = lib.types.path;
    description = "Root of hmconfigs.";
    default = ./.;
  };

  # TODO: Conditional import
  imports = [
    ./common/default.nix
    ./darwin/default.nix
    # ./linux/default.nix
  ];
}
