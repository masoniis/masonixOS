{
  programs.nixvim.autoGroups = {
    yankGrp.clear = true;
  };

  programs.nixvim.autoCmd = [
    {
      # Highlight on yank
      event = [ "TextYankPost" ];
      command = "lua vim.highlight.on_yank()";
      group = "yankGrp";
    }
    {
      # Check if any buffers were changed while unfocused
      event = [ "FocusGained" ];
      command = "checktime";
    }
    {
      # Stop neovim from creating new comment lines
      # automatically when pressing enter or o/O
      event = [ "BufEnter" ];
      command = "set formatoptions-=cro";
    }
    {
      # Insert mode when opening new terminals
      event = [ "TermOpen" ];
      command = "startinsert";
    }
    {
      # Remove gutter line numbers in terminal
      event = [ "TermOpen" ];
      command = "setlocal nonumber norelativenumber";
    }
  ];
}
