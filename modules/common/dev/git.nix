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
    settings = {
      user = {
        name = "mason";
        email = "58895787+masoniis@users.noreply.github.com";
      };
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
