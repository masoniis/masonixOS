# for testing packages
{ root, ... }:
{
  xdg.configFile.hypr = {
    source = "${root}/dotfiles/hypr";
    recursive = true;
  };
}
