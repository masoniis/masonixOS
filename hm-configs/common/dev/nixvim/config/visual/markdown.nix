{ ... }:
{
  programs.nixvim = {
    plugins.render-markdown = {
      enable = true;
      settings = {
        bullet = {
          icons = [
            "◆ "
            "• "
            "• "
          ];
          right_pad = 1;
        };
        code = {
          above = " ";
          below = " ";
          border = "thick";
          language_pad = 2;
          left_pad = 2;
          position = "right";
          right_pad = 2;
          sign = false;
          width = "block";
        };
        heading = {
          border = true;
          icons = [
            "1 "
            "2 "
            "3 "
            "4 "
            "5 "
            "6 "
          ];
          position = "inline";
          sign = false;
          width = "full";
        };
        render_modes = true;
        signs = {
          enabled = false;
        };
      };
    };
  };
}
