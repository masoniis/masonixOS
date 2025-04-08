{
  lib,
  pkgs,
  config,
  ...
}:
{
  config = lib.mkIf config.personal.enable {
    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0" # Required for obsidian
    ];
    home.packages = with pkgs; [
      obsidian
      (timetrack { obsidianVaultPath = "/Users/mason/obsidian/obsidian"; }) # masonpkgs
    ];
  };
}
