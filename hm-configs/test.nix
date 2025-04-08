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

  imports = [
    ./common/default.nix
  ];
}
