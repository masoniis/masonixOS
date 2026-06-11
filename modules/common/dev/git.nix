{ pkgs, ... }:
{
  home.packages = [
    pkgs.git-crypt
    pkgs.diffnav
    pkgs.delta
  ];

  programs.lazygit = {
    enable = true;
    settings = {
      notARepository = "skip";
      git = {
        pagers = [
          {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          }
        ];
        # tells lazygit to stop dropping to the terminal for signed commits
        overrideGpg = true;
      };
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
      merge.conflictstyle = "diff3";
      pager.diff = "diffnav";
      diff = {
        colorMoved = "default";
      };
      init.defaultBranch = "main";
      pull.rebase = true; # default to rebase pull
      fetch = {
        prune = true; # auto prune deleted remote branches from local
        pruneTags = true; # auto prune deleted remote tags from local
      };
    };

    ignores = [
      ".DS_Store"
      "GEMINI.md"
      "claude.md"
      ".gemini"
      ".antigravitycli"
      ".agents"
    ];
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
}
