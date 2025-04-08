{ pkgs, ... }:
{
  # This repo is deprecated, but the plugin still works for now
  programs.nixvim = {
    plugins.smart-splits = {
      enable = true;
      settings = {
        default_amount = 1;
        cursor_follows_swapped_bufs = true;
      };
    };

    keymaps = [
      # Swapping buffers between windows
      {
        mode = "n";
        key = "<leader><leader>h";
        action = "<cmd>lua require('smart-splits').swap_buf_left()<cr>";
        options.desc = "swap buffer leftward";
      }
      {
        mode = "n";
        key = "<leader><leader>j";
        action = "<cmd>lua require('smart-splits').swap_buf_down()<cr>";
        options.desc = "swap buffer downward";
      }
      {
        mode = "n";
        key = "<leader><leader>k";
        action = "<cmd>lua require('smart-splits').swap_buf_up()<cr>";
        options.desc = "swap buffer upward";
      }
      {
        mode = "n";
        key = "<leader><leader>l";
        action = "<cmd>lua require('smart-splits').swap_buf_right()<cr>";
        options.desc = "swap buffer rightward";
      }

      # Moving between splits
      {
        mode = "n";
        key = "<C-h>";
        action = "<cmd>lua require('smart-splits').move_cursor_left()<cr>";
        options.desc = "move cursor a window left";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<cmd>lua require('smart-splits').move_cursor_down()<cr>";
        options.desc = "move cursor a window down";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<cmd>lua require('smart-splits').move_cursor_up()<cr>";
        options.desc = "move cursor a window up";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<cmd>lua require('smart-splits').move_cursor_right()<cr>";
        options.desc = "move cursor a window right";
      }

      # Resizing splits
      {
        mode = "n";
        key = "<A-h>";
        action = "<cmd>lua require('smart-splits').resize_left()<cr>";
        options.desc = "resize window right";
      }
      {
        mode = "n";
        key = "<A-j>";
        action = "<cmd>lua require('smart-splits').resize_down()<cr>";
        options.desc = "resize window down";
      }
      {
        mode = "n";
        key = "<A-k>";
        action = "<cmd>lua require('smart-splits').resize_up()<cr>";
        options.desc = "resize window up";
      }
      {
        mode = "n";
        key = "<A-l>";
        action = "<cmd>lua require('smart-splits').resize_right()<cr>";
        options.desc = "resize window up";
      }

      # Terminal mode mappings
      {
        mode = "t";
        key = "<C-h>";
        action = "<Cmd>wincmd h<CR>";
        options = {
          silent = true;
        };
      }
      {
        mode = "t";
        key = "<C-j>";
        action = "<Cmd>wincmd j<CR>";
        options = {
          silent = true;
        };
      }
      {
        mode = "t";
        key = "<C-k>";
        action = "<Cmd>wincmd k<CR>";
        options = {
          silent = true;
        };
      }
      {
        mode = "t";
        key = "<C-l>";
        action = "<Cmd>wincmd l<CR>";
        options = {
          silent = true;
        };
      }
      {
        mode = "t";
        key = "<C-w>";
        action = "<C-\\><C-n><C-w>";
        options = {
          silent = true;
        };
      }
    ];
  };
}
