{ lib, ... }:
let
  findFileBySuffix =
    dir: suffix:
    let
      files = builtins.readDir dir;
      filenames = lib.attrNames files;
      foundFile = lib.findFirst (name: lib.hasSuffix suffix name) null filenames;
    in
    if foundFile != null then
      dir + "/${foundFile}"
    else
      throw "masonix nixCats config: Could not find file with suffix '${suffix}' in ${dir}";
in
{
  nixCats = {
    enable = true;
    luaPath = ./nvim;

    packageNames = [ "onixNvim" ];
    packageDefinitions.replace = {
      onixNvim =
        { pkgs, ... }:
        {
          settings = {
            aliases = [
              "vim"
              "vi"
              "n"
              "nv"
              "nvi"
              "nvim"
            ];
          };

          # Determines which plugin categories to enable
          categories = {
            necessary = true;
            lua.enable = true;
            java.enable = true;
            general = true;

            javaPaths = {
              java_debug_dir = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server";
              java_test_dir = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server";
            };
          };
        };
    };

    categoryDefinitions.replace = (
      {
        pkgs,
        settings,
        categories,
        extra,
        name,
        mkPlugin,
        ...
      }:
      {
        lspsAndRuntimeDeps = with pkgs; {
          lua = [
            lua-language-server
            stylua
          ];

          java = [
            jdt-language-server
            vscode-extensions.vscjava.vscode-java-test
            vscode-extensions.vscjava.vscode-java-debug
          ];

          general = [
            ripgrep
            fd
          ];
        };

        # Even though every plugin is a "startup plugin",
        # lazy-nvim can manage the lazy loading of them.
        startupPlugins = {

          # All necessary baseline plugins
          necessary = with pkgs.vimPlugins; [
            lazy-nvim

            # Common dependencies
            nvim-web-devicons
            nvim-lspconfig
            plenary-nvim
          ];

          lua = with pkgs.vimPlugins; [
            lazydev-nvim
          ];

          # General use plugins
          general = with pkgs.vimPlugins; [
            barbar-nvim
            catppuccin-nvim
            fidget-nvim
            gitsigns-nvim
            neo-tree-nvim
            nvim-dap-ui
            nvim-jdtls
            snacks-nvim
            todo-comments-nvim
            which-key-nvim
          ];
        };
      }
    );
  };
}
