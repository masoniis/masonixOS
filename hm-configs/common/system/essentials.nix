{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fira-code-nerdfont # decent nerd font
    neofetch # Show os info and such
  ];
}
