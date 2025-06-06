{
  config,
  root,
  pkgs,
  ...
}:
{
  # ghostty only available on linux in nixpkgs at the moment
  home.packages =
    with pkgs;
    [
      # ghostty  #broken on mac currently
      fswatch
      watch
      parallel
      ripgrep
      # TODO: better place for this?
      mitmproxy
      wget
    ]
    ++ (if config.isLinux then [ pkgs.ghostty ] else [ ]);

  # INFO: Source dotfiles directly
  xdg.configFile = {
    wezterm = {
      source = root + /dotfiles/wezterm;
      recursive = true;
    };
    ghostty = {
      source = root + /dotfiles/ghostty;
      recursive = true;
    };
  };

  home.shellAliases = {
    cat = "bat";
  };

  # INFO: Programs
  programs = {
    starship.enable = true; # shell prompts
    # better cd command
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
    # better cat command
    bat.enable = true;
    # better ls command
    eza = {
      enable = true;
      enableZshIntegration = true;
    };
    # shell
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      initContent = ''
        set -o vi
      '';
      profileExtra =
        # adds docker desktop to path for macos
        # TODO: better solution?
        if config.isDarwin then
          ''
            export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"
          ''
        else
          "";
      completionInit = "
				bindkey '^ ' autosuggest-accept
				bindkey '^l' autosuggest-accept
			";
    };
  };
}
