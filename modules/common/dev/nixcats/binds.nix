{
  leader = " ";
  new_file = "<leader>fn"; # FIXME: conflicts with ...
  change_dir = "<leader>cd";
  close_window = "<C-q>";
  save_buffer = "<C-s";
  which_key = "<leader>?";
  system = rec {
    # relating to files and the system
    group = "<leader>s";
    reveal_file = "${group}r";
    copy_file_path = "${group}f"; # copy the (absolute) file path associated with the open buffer
    open_file = "${group}b";
    copy_file = "${group}c";
    open_in_github = "${group}g";
  };
  find = rec {
    group = "<leader>f";
    find_files = "${group}f";
    find_recent = "${group}r";
    find_notifications = "${group}n";
    find_grep_git = "${group}g";
    find_git_files = "${group}G";
    find_pickers = "${group}p";
  };
  snacks = {
    dashboard = "<leader><leader><leader>";
    git_blame_line = "<leader>gb";
  };
  terminals = rec {
    group = "<leader>t";
    lazygit = "${group}l";
    floaterm_toggle = "${group}t";
    floaterm_new = "<C-a>";
    ollama = "${group}o";
    home_manager = "${group}h";
    spotify = "${group}s";
    flutter = "${group}f";
  };
  files = {
    explorer = "<leader>e";
    float = "<leader>E";
  };
  splits = {
    # related to window management
    close = "<leader>q";
    swap_left = "<leader><leader>h";
    swap_down = "<leader><leader>j";
    swap_up = "<leader><leader>k";
    swap_right = "<leader><leader>l";
    move_left = "<C-h>";
    move_down = "<C-j>";
    move_up = "<C-k>";
    move_right = "<C-l>";
    resize_left = "<A-h>";
    resize_down = "<A-j>";
    resize_up = "<A-k>";
    resize_right = "<A-l>";
    vertical_split = "<leader>|";
    horizontal_split = "<leader>-";
  };
  editing = {
    rename = "<leader>rn";
    buffer_close = "-";
    buffer_previous = "<C-,>";
    buffer_next = "<C-.>";
    buffer_move_next = "<C-S-.>";
    buffer_move_previous = "<C-S-,>";
  };
  debug = rec {
    group = "<leader>d";
    toggle_breakpoint = "${group}b";
    continue = "${group}c";
    step_over = "${group}o";
    step_into = "${group}i";
    step_out = "<Left>";
    step_into_alt = "<Right>";
    toggle_ui = "${group}u";
  };
  lsp = rec {
    group = "<leader>l";
    code_action = "${group}a";
    declaration = "${group}D";
    definition = "${group}d";
    fix_all = "${group}F";
    diagnostics_float = "${group}f";
    implementation = "${group}i";
    hover = "<leader>K";
    type_definition = "${group}t";
    rename_symbol = "${group}n";
    references = "${group}r";
  };
}
