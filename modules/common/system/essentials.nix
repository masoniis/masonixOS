{
  pkgs,
  lib,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    neofetch # eblic show system stuff
    fzf # useful for piping commands into searches
    dua # disk usage analyzer tool

    # font stuff
    fontconfig
    noto-fonts
    nerd-fonts.fira-code # mono nerd font
    # emojis
    noto-fonts-emoji
    noto-fonts-monochrome-emoji
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [
        "Noto Color Emoji"
        "Noto Monochrome Emoji"
      ];
      monospace = [ "FiraCode Nerd Font" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  # Fix for allowing fontconfig over coretext (apple builtin) on darwin
  home.sessionVariables = lib.optionalAttrs config.isDarwin {
    FONTCONFIG_FILE = pkgs.makeFontsConf {
      fontDirectories = [
        "/System/Library/Fonts"
        "/Library/Fonts"
      ];
    };
  };
}
