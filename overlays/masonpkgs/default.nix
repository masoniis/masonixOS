final: prev:
let
  lib = prev.lib;

  # INFO: --------------------------------------------------------------
  #         auto read nvim-plugins dir to an attr set for overlay
  # --------------------------------------------------------------------

  pluginsPath = ./nvim-plugins;
  pluginFiles = lib.attrNames (
    lib.filterAttrs (name: type: type == "regular" && lib.strings.hasSuffix ".nix" name) (
      builtins.readDir pluginsPath
    )
  );

  customVimPlugins = lib.listToAttrs (
    lib.map (file: {
      # plugin name for the vim plugin overlay is based on file name + masonpkgs
      # "slimline.nix" -> "slimline-masonpkgs"
      name = "${lib.strings.removeSuffix ".nix" file}-masonpkgs";
      value = prev.callPackage (pluginsPath + "/${file}") { };
    }) pluginFiles
  );
in
{
  entire-masonpkgs = prev.callPackage ./entire/default.nix { };
  run-in-roblox = prev.callPackage ./run-in-roblox/default.nix { };

  timetrack = prev.callPackage ./timetrack/default.nix { };
  vimPlugins = prev.vimPlugins // customVimPlugins;

  mpvacious = prev.callPackage ./mpvacious/default.nix {
    inherit (prev.mpvScripts) buildLua;
  };
  mpvScripts = prev.mpvScripts // {
    mpvacious = final.mpvacious;
  };
}
