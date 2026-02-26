{ pkgs, ... }:
{
  home.packages = [
    pkgs.git-crypt
    pkgs.diffnav
  ];

  programs.lazygit = {
    enable = true;
    settings = {
      notARepository = "skip";
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "mason";
    userEmail = "58895787+masoniis@users.noreply.github.com";
    delta = {
      enable = true;
      options = {
        true-color = "always"; # syntax highlighting
        navigate = true; # use n/N for nav
        light = false;
      };
    };

    extraConfig = {
      merge.tool = "nvimdiff2";
      merge.conflictstyle = "diff3";
      pager.diff = "diffnav";
      diff = {
        colorMoved = "default";
      };
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
