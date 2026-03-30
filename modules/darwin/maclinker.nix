{ lib, ... }:
{
  # This script symlinks all of the nix apps into the mac applications folder
  # and copies some files directly like icons. This results in better support
  # for applications like apple spotlight, where it can properly find the app
  # and also apply the correct icons that would otherwise fail with symlinks.

  # NOTE:
  # I called the folder `masonix` just so if you ever wonder why the folder
  # exists you will know it was generated directly by masonix. This also
  # lowers the chance of any conflict with nix/nix-darwin in the future

  home.activation = {
    theMacLinker = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      # Create directory, remove old
      mkdir -p "$HOME/Applications/masonix"
      rm -rf "$HOME/Applications/masonix"/*
      mkdir -p "$HOME/Applications/masonix"

      # Get the target of the symlink
      NIXAPPS=$(readlink -f "$HOME/.nix-profile/Applications")
      # For each application
      for app_source in "$NIXAPPS"/*; do
        if [ -d "$app_source" ] || [ -L "$app_source" ]; then
          appname=$(basename "$app_source")
          target="$HOME/Applications/masonix/$appname"
          
          # Create the basic structure
          mkdir -p "$target"
          mkdir -p "$target/Contents"
          
          # Copy the Info.plist file
          if [ -f "$app_source/Contents/Info.plist" ]; then
            mkdir -p "$target/Contents"
            cp -f "$app_source/Contents/Info.plist" "$target/Contents/"
          fi
          
          # Copy ONLY icon-related resources
          if [ -d "$app_source/Contents/Resources" ]; then
            mkdir -p "$target/Contents/Resources"
            
            # Copy Assets.car
            if [ -f "$app_source/Contents/Resources/Assets.car" ]; then
              cp -f "$app_source/Contents/Resources/Assets.car" "$target/Contents/Resources/"
            fi
            
            # Copy all .icns files
            find "$app_source/Contents/Resources" -name "*.icns" -exec cp -f {} "$target/Contents/Resources/" \;
          fi
          
          # Symlink the MacOS directory (contains the actual binary)
          if [ -d "$app_source/Contents/MacOS" ]; then
            ln -sfn "$app_source/Contents/MacOS" "$target/Contents/MacOS"
          fi
          
          # Symlink other directories
          for dir in "$app_source/Contents"/*; do
            dirname=$(basename "$dir")
            if [ "$dirname" != "Info.plist" ] && \
               [ "$dirname" != "Resources" ] && \
               [ "$dirname" != "MacOS" ]; then
              ln -sfn "$dir" "$target/Contents/$dirname"
            fi
          done
        fi
      done
    '';
  };
}
