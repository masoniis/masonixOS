{ config, ... }:
{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;
      luaConfig.post = ''
        local flakePath = "${config.flakePath}"
        ${builtins.readFile ./toggleterm.lua}
      '';
    };
  };
}
