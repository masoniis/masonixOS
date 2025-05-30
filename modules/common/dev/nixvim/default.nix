{
  lib,
  pkgs,
  ...
}:
let
  pluginsDir = ./config;
  allFiles = lib.filesystem.listFilesRecursive pluginsDir;
  imports = builtins.filter (path: lib.hasSuffix ".nix" (toString path)) allFiles;
in
{
  inherit imports;
  home.packages = with pkgs; [
    fd
    ripgrep
    tree-sitter
  ];

  programs.nixvim = {
    enable = true;
    luaLoader.enable = true;
    defaultEditor = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      termguicolors = true;
      number = true;
      numberwidth = 5;
      cursorline = true;
      cursorlineopt = "both";
      clipboard = "unnamedplus"; # Neovim and OS clipboard are friends now
      tabstop = 2; # Tab length 4 spaces
      shiftwidth = 2; # 4 spaces when indenting with '>'
      smartcase = false; # Ignore case if pattern is all lowercase
      ignorecase = false; # make patterns case insinsitive
      cmdheight = 0; # When a command is not being typed, height is 0 instead of 1 line
      scrolloff = 2; # Handled in VSCode settings, makes it so it starts scrolling before cursor reaches e
      sidescrolloff = 8; # Handled in VSCode settings
      laststatus = 3;
      # Folding options
      foldmethod = "indent";
      foldlevel = 99; # Fold this many indentations (essentially inf)
      # foldmethod = "expr";
      # foldexpr = "nvim_treesitter#foldexpr()"; # nvim-treesitter folding
      foldenable = false;
      timeoutlen = 100; # Controls how fast whichkey appears among other things
      relativenumber = true;
      fillchars = {
        diff = "╱";
      };
      completeopt = "popup,menu,menuone,noselect"; # Completion options
      splitright = true; # Split windows to the right instead of left
      # autochdir = true;
      hidden = true; # Allow hidden buffers for things like toggleterm
      exrc = true; # Allow local vimrc, nvim.lua, .exrc in projects to apply to nvim conf
    };
  };
}
