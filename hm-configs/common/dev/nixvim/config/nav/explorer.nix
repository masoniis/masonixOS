{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      neo-tree = {
        enable = true;
        extraOptions = {
          filesystem = {
            bind_to_cwd = true; # true creates a 2-way binding between vim's cwd and neo-tree's root
            cwd_target = {
              sidebar = "tab"; # sidebar is when position = left or right
              current = "window"; # current is when position = current
            };
          };
          # NOTE: The pattern for a rule uses neovim regex, but the files pattern uses glob style patterns
          nesting_rules.__raw = ''
            (function()
              local rules = require("neotree-file-nesting-config").nesting_rules
              -- Any NAME.nix file with corresponding NAME.lua or NAME-any.lua gets collapsed
              rules["nixvim_lua"] = {
                pattern = "(.*).nix$",
                files = { "%1%.lua", "%1-*%.lua" }
              }
              rules["protobuf"] = {
                pattern = "(.*).proto",
                files = { "%1%.pb.dart", "%1%.pbenum.dart", "%1%.pbjson.dart", "%1%.pbserver.dart" }
              }
              return rules
            end)()
          '';
          window.mappings = {
            "<S-CR>" = {
              command = "toggle_node";
            };
          };
        };
      };
    };

    keymaps = [
      {
        action = "<cmd>Neotree toggle source=filesystem reveal=true position=left<cr>";
        mode = "n";
        key = "<leader>e";
        options.desc = "explorer";
      }
    ];

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "neotree-file-nesting-config";
        src = pkgs.fetchFromGitHub {
          owner = "saifulapm";
          repo = "neotree-file-nesting-config";
          rev = "089adb6d3e478771f4485be96128796fb01a20c4";
          sha256 = "VCwujwpiRR8+MLcLgTWsQe+y0+BYL9HRZD+OzafNGGA=";
        };
      })
    ];
  };
}
