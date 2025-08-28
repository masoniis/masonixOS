# Overlay used to "inject" custom packages into nixpkgs
self: super: {
  lobster = args: super.callPackage ./lobster/default.nix args;
  jerry = args: super.callPackage ./jerry/default.nix args;
  timetrack = args: super.callPackage ./timetrack/default.nix args;

  vimPlugins = super.vimPlugins // {
    slimline-nvim = super.callPackage ./nvim-plugins/slimline.nix { };
    neotree-nesting-config-nvim = super.callPackage ./nvim-plugins/neotree-nesting-config.nix { };
  };
}
