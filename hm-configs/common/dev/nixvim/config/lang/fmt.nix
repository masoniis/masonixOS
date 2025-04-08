{
  lib,
  pkgs,
  ...
}:
{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          timeout_ms = 500;
          lsp_fallback = true;
        };
        default_format_opts.lsp_format = "fallback";
        formatters_by_ft = {
          lua = [ "stylua" ];
          python = [
            "isort"
            "black"
          ];
          javascript = [ "prettierd" ];
          typescript = [ "prettierd" ];
          typescriptreact = [ "prettierd" ];
          html = [ "prettierd" ];
          rust = [ "rustfmt" ];
          nix = [ "nixfmt" ];
          "*" = [ "codespell" ];
          "_" = [ "trim_whitespace" ];
        };
        formatters = {
          nixfmt.command = lib.getExe pkgs.nixfmt-rfc-style;
          stylua.command = lib.getExe pkgs.stylua;
          prettierd.command = lib.getExe pkgs.prettierd;
          rustfmt.command = lib.getExe pkgs.rustfmt;
          black.command = lib.getExe pkgs.black;
          isort.command = lib.getExe pkgs.isort;
          codespell.command = lib.getExe pkgs.codespell;
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        action = ''<cmd>lua require("conform").format({ async = true, lsp_fallback = true })<cr>'';
        key = "<leader>F";
        options.desc = "reformat";
      }
    ];
  };
}
