{ config, ... }:
{
  # home.packages = with pkgs; [ghostty]; #broken on mac currently

  # INFO: Source dotfiles directly
  xdg.configFile = {
    wezterm = {
      source = config.root + /dotfiles/wezterm;
      recursive = true;
    };
    ghostty = {
      source = config.root + /dotfiles/ghostty;
      recursive = true;
    };
  };

  home.shellAliases = {
    cat = "bat";
  };

  # INFO: Programs
  programs = {
    wezterm.enable = true; # terminal emulator
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
      initExtra = ''
        set -o vi
      '';
      completionInit = "
				bindkey '^ ' autosuggest-accept
				bindkey '^[l' autosuggest-accept
			";
    };
  };
}
