# Package to update simple-time-tracker blocks in obsidian, start/stopping
{
  pkgs,
  obsidianVaultPath ? ".",
  ...
}:
let
  # Create proper Python script package
  pythonVisualizer = pkgs.writeScriptBin "visualize-timetrack" ''
    #!${pkgs.python3}/bin/python3
    ${builtins.readFile ./vis_timetrack.py}
  '';

  # Main bash script
  bashScript = pkgs.writeScriptBin "timetrack" ''
    #!/bin/bash
    DEFAULT_SEARCH_PATH="${obsidianVaultPath}"
    ${builtins.readFile ./timetrack.sh}
  '';
in
pkgs.symlinkJoin {
  name = "timetrack";
  paths = [
    bashScript
    pythonVisualizer
  ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/timetrack \
      --prefix PATH : ${
        pkgs.lib.makeBinPath [
          pkgs.jq
          pkgs.fzf
          pkgs.python3
          pythonVisualizer
        ]
      }
  '';
}
