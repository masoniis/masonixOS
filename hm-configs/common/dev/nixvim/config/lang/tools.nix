{
  programs.nixvim = {
    plugins.flutter-tools = {
      enable = true;
      settings = {
        widget_guides = {
          enabled = true;
        };
        lsp = {
          renameFilesWithClasses = "prompt";
          completeFunctionCalls = true;
          updateImportsOnRename = true;
          enableSnippets = true;
          showTodos = true;
          color = {
            enabled = true;
            foreground = true;
          };
        };
      };
      flutterPackage = null; # use devshell
    };
  };
}
