{ pkgs, ... }:
{
  home.packages = [ pkgs.git-crypt ];

  programs.lazygit = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "mason";
    userEmail = "58895787+masoniis@users.noreply.github.com";
    extraConfig = {
      sendemail = {
        smtpserver = "smtp.gmail.com";
        smtpuser = "masonmbott@gmail.com";
        smtpencryption = "tls";
        smtpserverport = 587;
      };
      merge.tool = "nvimdiff2";
      init.defaultBranch = "main";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
}
