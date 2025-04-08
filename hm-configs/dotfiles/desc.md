Directory that houses all the source files that symlinks in ~/.config will point to.
- Some files like neovim are symlinked so that nix doesn't collide with things like `lazy-lock.json`. This allows our neovim to still maintain some reproducability despite having it's own internal non-nixified package manager.
