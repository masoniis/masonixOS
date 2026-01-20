{ pkgs, ... }:
{
  home.packages = [ pkgs.git-crypt ];

  programs.lazygit = {
    enable = true;
    settings = {
      notARepository = "skip";
    };
  };

  programs.git = {
    enable = true;
    userName = "mason";
    userEmail = "58895787+masoniis@users.noreply.github.com";
    extraConfig = {
      merge.tool = "nvimdiff2";
      init.defaultBranch = "main";
      pull.rebase = false; # default to merging
      fetch = {
        prune = true; # auto prune deleted remote branches from local
        pruneTags = true; # auto prune deleted remote tags from local
      };
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
}
