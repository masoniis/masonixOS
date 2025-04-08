{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = lib.mkIf config.personal.enable {
    nixpkgs.config.allowUnfree = true; # discord = unfree

    home.packages = [
      #INFO: On mac, since this modifies signed discord, it now has to be allowed in security settings.
      # ALso, see https://github.com/NixOS/nixpkgs/issues/208749 for errors with openasar "module not found"
      # TLDR: Open regular discord once to get openASAR to work, and then enable openASAR
      (pkgs.discord.override {
        # withOpenASAR = true;
        withVencord = true;
      })
    ];
  };
}
