{ lib, ... }:
{
  options.personal.enable = lib.mkEnableOption "enable personal modules" // {
    default = false;
  };

  imports = [
    ./entertainment.nix
    ./productivity.nix
    ./social.nix
  ];
}
