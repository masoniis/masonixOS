{
  programs.nixvim.config.keymaps = [
    # INFO: Normal mode mappings
    {
      mode = "n";
      key = "<C-s>";
      action = "<cmd>w<cr>";
      options = {
        silent = true;
        desc = "save file";
      };
    }
    {
      mode = "n";
      key = "<leader>cd";
      action = "<cmd>cd %:h<cr>";
      options = {
        silent = true;
        desc = "change file dir";
      };
    }
    {
      mode = "n";
      key = "<leader>-";
      action = "<cmd>split<cr>";
      options = {
        silent = true;
        desc = "horizontal split";
      };
    }
    {
      mode = "n";
      key = "<leader>|";
      action = "<cmd>vsplit<cr>";
      options = {
        silent = true;
        desc = "vertical split";
      };
    }
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>q<cr>";
      options = {
        silent = true;
        desc = "quit";
      };
    }
    {
      mode = "n";
      key = "<esc>";
      action = "<cmd>nohlsearch<cr><esc>";
      options = {
        silent = true;
        noremap = true;
        nowait = true;
        desc = "clear search highlight";
      };
    }
    {
      mode = "n";
      key = "<leader>uh";
      action = "<cmd>noh<cr>";
      options = {
        silent = true;
        desc = "";
      };
    }
    # Swap gj & j and gk & k to allow for easier navigation in wrapped lines
    {
      mode = "n";
      key = "j";
      action = "gj";
      options = {
        silent = true;
      };
    }
    {
      mode = "n";
      key = "k";
      action = "gk";
      options = {
        silent = true;
      };
    }
    {
      mode = "n";
      key = "gk";
      action = "k";
      options = {
        silent = true;
      };
    }
    {
      mode = "n";
      key = "gj";
      action = "j";
      options = {
        silent = true;
      };
    }
    # System mappings
    {
      mode = "n";
      key = "<leader>sr";
      action.__raw = ''
        function()
          local file = vim.fn.expand('%:p')
          if vim.fn.filereadable(file) ~= 1 then
            vim.notify("No file to reveal")
            return
          end

          local sysname = vim.loop.os_uname().sysname
          local cmd
          if sysname == "Darwin" then
            cmd = 'open -R "' .. file .. '"'
          elseif sysname == "Windows_NT" then
            cmd = 'explorer /select,"' .. file .. '"'
          else
          -- Linux: open the containing directory
          local dir = vim.fn.fnamemodify(file, ":h")
            cmd = 'xdg-open "' .. dir .. '"'
          end
            os.execute(cmd)
          end
      '';
      options = {
        silent = true;
        desc = "reveal in system explorer";
      };
    }
    {
      mode = "n";
      key = "<leader>sf";
      action.__raw = ''
        function()
          local file = vim.fn.expand('%:p')
          if file == "" or vim.fn.filereadable(file) ~= 1 then
            vim.notify("No file path to copy")
            return
          end

          local sysname = vim.loop.os_uname().sysname
          local copy_cmd

          if sysname == "Darwin" then
            copy_cmd = 'echo "' .. file .. '" | pbcopy'
          elseif sysname == "Windows_NT" then
            copy_cmd = 'echo ' .. file .. ' | clip'
          else
          -- Linux: try wl-copy (Wayland) first, fallback to xclip
          if vim.fn.executable("wl-copy") == 1 then
            copy_cmd = 'echo "' .. file .. '" | wl-copy'
          elseif vim.fn.executable("xclip") == 1 then
            copy_cmd = 'echo "' .. file .. '" | xclip -selection clipboard'
          else
            vim.notify("No clipboard utility (wl-copy or xclip) found")
            return
          end
        end

        os.execute(copy_cmd)
        vim.notify("Copied: " .. file)
        end
      '';
      options = {
        silent = true;
        desc = "copy system file path";
      };
    }
    {
      mode = "n";
      key = "<leader>sc";
      action.__raw = ''
        function()
          local file = vim.fn.expand("%:p")
          if file == "" or vim.fn.filereadable(file) ~= 1 then
            vim.notify("No valid file to copy")
            return
          end

          local sysname = vim.loop.os_uname().sysname
          local cmd

          if sysname == "Darwin" then
          -- macOS: copy file reference
            cmd = "osascript -e 'set the clipboard to (POSIX file \"" .. file .. "\")'"
          elseif sysname == "Windows_NT" then
          -- Windows: powershell copy
            cmd = "powershell.exe -Command \"Set-Clipboard -Path '" .. file .. "'\""
          else
            if vim.fn.executable("wl-copy") == 1 then
              cmd = "printf 'file://" .. file .. "' | wl-copy --type text/uri-list"
            elseif vim.fn.executable("xclip") == 1 then
              cmd = "printf 'file://" .. file .. "' | xclip -selection clipboard -t text/uri-list"
            else
              vim.notify("Clipboard file copy unsupported on this platform")
            return
            end
          end

          os.execute(cmd)
          vim.notify("Copied file reference to clipboard: " .. file)
        end
      '';
      options = {
        silent = true;
        desc = "copy file";
      };
    }

    # INFO: Visual mode mappings
    {
      mode = "v";
      key = "p";
      action = "\"_dP";
      options = {
        silent = true;
      };
    }

    # INFO: Terminal mode mappings
    {
      mode = "t";
      key = "<esc><esc>";
      # exit term mode -> go to norm mode
      action = "<C-\\><C-n>";
      options = {
        silent = true;
        noremap = true;
        nowait = true;
      };
    }
  ];
}
