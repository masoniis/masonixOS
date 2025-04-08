{
  lib,
  pkgs,
  root,
  config,
  ...
}:
{
  options.entertainment.enable = lib.mkEnableOption "enable entertainment modules" // {
    default = false;
  };

  config = lib.mkIf config.entertainment.enable {
    #INFO: Source 4k upscale shaders for anime.
    # Note for IINA: must import the input.conf as keybindings manually
    xdg.configFile.mpv = {
      source = pkgs.fetchzip {
        url = "https://github.com/Tama47/Anime4K/releases/download/v4.0.1/GLSL_Mac_Linux_Low-end.zip";
        sha256 = "1v4cxx6lay3vzwm5d9ns8k3crg4zd9p9kylpzbi789pymqkaz1ng"; # nix-preferch-url --unpack hash
        # HIGH END ALTERNATIVE
        # 	url = "https://github.com/Tama47/Anime4K/releases/download/v4.0.1/GLSL_Mac_Linux_High-end.zip";
        # 	sha256 = "1d50zzqwyh264rbqj3dr9hdylcjs4xbji95hrna5icl3a2fmy7q2"; # nix-preferch-url --unpack hash
        stripRoot = false; # Assume multiple files, which requires --unpack hash
      };
      recursive = true;
    };

    # TODO: Fix jerry/lobster on linux. Not sure why not launching
    xdg.configFile.jerry = {
      source = root + /dotfiles/jerry;
      recursive = true;
    };

    xdg.configFile.lobster = {
      source = root + /dotfiles/lobster;
      recursive = true;
    };

    home.packages = [
      pkgs.ffmpeg # Common dependency, used for stacher as well as general use
      (pkgs.jerry {
        withIINA = if pkgs.stdenv.isDarwin then true else false;
        imagePreviewSupport = true;
      })
      (pkgs.lobster {
        withIINA = if pkgs.stdenv.isDarwin then true else false;
      })
      pkgs.spotifyd
    ];

    programs.spotify-player = {
      enable = true;
      settings = {
        enable_notify = false;
        device = {
          volume = 100; # make initial volume 70 -> 100 so that laptop has full control
        };
      };
      keymaps = [
        {
          command = "None"; # Disable q for nvim toggleterm, so that we can leave terminal without closing player
          key_sequence = "q";
        }
        {
          command = "FocusNextWindow";
          key_sequence = "C-l";
        }
        {
          command = "FocusPreviousWindow";
          key_sequence = "C-h";
        }
      ];
    };

    home.shellAliases = {
      jerry = "command jerry --dub";
      jerrysub = "command jerry";
      spt = "spotify_player";
    };
  };
}
