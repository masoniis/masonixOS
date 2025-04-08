{
  programs.nixvim.plugins.flash.enable = true;
  programs.nixvim.keymaps = [
    {
      key = "s";
      mode = [
        "n"
        "x"
        "o"
      ];
      action.__raw = "function() require('flash').jump() end";
      options.desc = "flash";
    }
    {
      key = "S";
      mode = [
        "n"
        "x"
        "o"
      ];
      action.__raw = "function() require('flash').treesitter() end";
      options.desc = "flash treesitter";
    }
    {
      key = "r";
      mode = "o";
      action.__raw = "function() require('flash').remote() end";
      options.desc = "remote Flash";
    }
    {
      key = "R";
      mode = [
        "o"
        "x"
      ];
      action.__raw = "function() require('flash').treesitter_search() end";
      options.desc = "treesitter search";
    }
    {
      key = "<c-s>";
      mode = [ "c" ];
      action.__raw = "function() require('flash').toggle() end";
      options.desc = "toggle flash search";
    }
  ];
}
