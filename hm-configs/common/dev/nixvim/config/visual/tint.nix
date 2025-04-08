{ pkgs, ... }:
{
  # WARNING: This repo is deprecated, but the plugin still works for now
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "tint";
        src = pkgs.fetchFromGitHub {
          owner = "levouh";
          repo = "tint.nvim";
          rev = "586e87f00c8b0f5e857cefe10839e41f3e8c6d01";
          sha256 = "gmtFb/FirvTtWeTpalabWmt5kQiH83rE7gph3VcKcss=";
        };
      })
    ];

    extraConfigLua = ''
      require("tint").setup({
        -- Try to tint by `-10`, but keep all colors at least `3` away from `#1E1E2E`
        transforms = {
          require("tint.transforms").tint_with_threshold(-10, "#1E1E2E", 5),
          require("tint.transforms").saturate(0.5),
        },
        tint_background_colors = true, -- Tint background portions of highlight groups
        highlight_ignore_patterns = { "WinSeparator", "Status.*" }, -- Highlight group patterns to ignore, see `string.find`
        window_ignore_function = function(winid)
          local bufid = vim.api.nvim_win_get_buf(winid)
          local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
          local floating = vim.api.nvim_win_get_config(winid).relative ~= ""

          -- Do not tint `terminal` or floating windows, tint everything else
          -- return buftype == "terminal" or floating
          return floating
        end,
      })
    '';

    # INFO: Fixes an issue with tint not refreshing after closing snacks lazygit
    autoCmd = [
      {
        event = [ "TermClose" ];
        callback.__raw = ''
          function()
            vim.defer_fn(function()
              require("tint").untint(vim.api.nvim_get_current_win())
            end, 10)
          end
        '';
      }
    ];
  };
}
