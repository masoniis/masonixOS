{
  config,
  root,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  # ghostty only available on linux in nixpkgs at the moment
  # install it on macos manually bruv or use regular terminal
  home.packages = [
    pkgs.ripgrep
    pkgs.fd
    pkgs.fswatch
    pkgs.watch
    pkgs.parallel
    pkgs.mitmproxy
    pkgs.wget
    pkgs-unstable.claude-code
    pkgs.onefetch
  ]
  ++ lib.optional config.isLinux pkgs.ghostty;

  # INFO: Source dotfiles directly
  xdg.configFile = {
    wezterm = {
      source = "${root}/dotfiles/wezterm";
      recursive = true;
    };
    ghostty = {
      source = "${root}/dotfiles/ghostty";
      recursive = true;
    };
  };

  home.shellAliases = {
    cat = "bat";
  };

  # INFO: Programs
  programs = {
    starship = {
      enable = true; # shell prompts
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableTransience = true;
    };
    # better cd command
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };
    # better cat command
    bat.enable = true;
    # better ls command
    eza = {
      enable = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
    # shell(s)
    fish = {
      enable = true;
      interactiveShellInit = ''
        bind \cl 'commandline -f accept-autosuggestion'
        set -g fish_key_bindings fish_vi_key_bindings
      '';
    };
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      initContent = ''
        set -o vi
        bindkey '^l' autosuggest-accept
        export EDITOR=nvim
      '';
      profileExtra =
        ""
        + lib.optionalString config.isDarwin ''
          export PATH="$PATH:/Applications/Docker.app/Contents/Resources/bin/"
        '';
      completionInit = "
    	  bindkey '^ ' autosuggest-accept
    	  bindkey '^l' autosuggest-accept
			";
    };
  };
}
