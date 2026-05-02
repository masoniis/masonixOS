# Languages is the installation of interpreters, compilers, etc
# needed to run particular languages. Language servers are handled
# elsewhere
{ lib, ... }:
{
  options.language =
    lib.genAttrs [ "c" "python" ] (name: {
      enable = lib.mkEnableOption "enable ${name} modules" // {
        default = false;
      };
    })
    // lib.genAttrs [ ] (name: {
      enable = lib.mkEnableOption "enable ${name} modules" // {
        default = true;
      };
    }); # nix/lua are default for obvious reasons. Rust is default because it is dep for some neovim packages

  imports = [
    ./python.nix
    ./c.nix
  ];
}
