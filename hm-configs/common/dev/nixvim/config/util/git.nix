{ ... }:
{
  programs.nixvim = {
    plugins.gitsigns = {
      enable = true;
      settings.current_line_blame_opts.delay = 0;
    };

    plugins.diffview = {
      enable = true;
      enhancedDiffHl = true;
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>Gitsigns toggle_current_line_blame<cr>";
        options.desc = "toggle blame";
      }
      {
        mode = "n";
        key = "<leader>gd";
        action = "<cmd>DiffviewOpen<cr>";
        options.desc = "open diffview";
      }
    ];
  };
}
