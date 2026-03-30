{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ollama # run local ml models
  ];
}
