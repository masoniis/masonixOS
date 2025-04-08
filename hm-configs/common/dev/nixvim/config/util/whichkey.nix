{ ... }:
{
  programs.nixvim = {
    plugins.which-key = {
      enable = true;
      settings = {
        preset = "modern";
        win = {
          no_overlap = true;
          border = "single";
          wo.winblend = 10;
          padding = [
            0
            2
          ];
          title = true;
          title_pos = "center";
        };
        spec = [
          {
            __unkeyed = "<leader>f";
            group = "file";
          }
          {
            __unkeyed = "<leader><leader>";
            group = "swap windows";
          }
          {
            __unkeyed = "<leader>c";
            group = "change";
          }
          {
            __unkeyed = "<leader>l";
            group = "lsp";
          }
          {
            __unkeyed = "<leader>d";
            group = "debug";
          }
          {
            __unkeyed = "<leader>t";
            group = "terminal";
          }
          {
            __unkeyed = "<leader>s";
            group = "system";
          }
          {
            __unkeyed = "<leader>u";
            group = "un";
          }
          {
            __unkeyed = "<leader>r";
            group = "re";
          }
        ];
      };
    };
  };
}
