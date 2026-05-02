{ root, ... }:
{
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;

      config = {
        warn_timeout = "-1m"; # disable warning that direnv is taking long, common for any nixdirenv and gets annoying
        hide_env_diff = true; # hides the massive env export string that gets printed on entrance of direnv shell
      };
    };
  };

  home.shellAliases = {
    dr = "direnv reload";
    da = "direnv allow";
  };

  nix.registry.masonix.flake = root;
}
