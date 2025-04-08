{
  programs.nixvim = {
    # INFO: use snacks instead
    # plugins.notify.enable = true;
    plugins.noice = {
      enable = true;
      settings = {
        presets = {
          command_palette = true; # position the cmdline and popupmenu together
          long_message_to_split = true; # long messages will be sent to a split
          lsp_doc_border = true; # add a border to hover docs and signature help
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>un";
        action = ''<cmd>lua require("noice").cmd("dismiss")<cr>'';
        options.desc = "dismiss notifications";
        options.noremap = true;
      }
    ];
  };
}
