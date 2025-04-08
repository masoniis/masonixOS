{ lib, ... }:
{
  options.personal.enable = lib.mkEnableOption "enable personal modules" // {
    default = false;
  };

  imports = [
    ./gaming.nix
    ./productivity.nix
    ./entertainment.nix
  ];
}
