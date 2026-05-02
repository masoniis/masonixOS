# packages and config for productive activities
{
  lib,
  pkgs,
  config,
  pkgs-unstable,
  ...
}:
{
  config = lib.mkIf config.personal.enable {
    home.packages = [
      pkgs-unstable.obsidian # might as well pin to unstable since it is proprietary
      pkgs.zotero
      # pkgs.anki-bin # waiting for update to 25.07, they are having UV issues
      # clockify only on linux, time tracker
      (pkgs.timetrack {
        obsidianVaultPath = "/Users/mason/obsidian/obsidian";
      }) # masonpkgs
    ];
  };
}
