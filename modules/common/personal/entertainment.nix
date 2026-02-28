# packages and config for media and gaming
{
  pkgs-spice,
  pkgs-unstable,
  config,
  root,
  pkgs,
  lib,
  ...
}:
let
  enableSpice = true; # toggle between spicetify and regular spotify desktop

  # Note for IINA: must import the input.conf as
  # keybindings manually. Found in dotfiles directory
  anime4k-files = pkgs.fetchzip {
    url = "https://github.com/Tama47/Anime4K/releases/download/v4.0.1/GLSL_Mac_Linux_Low-end.zip";
    sha256 = "1v4cxx6lay3vzwm5d9ns8k3crg4zd9p9kylpzbi789pymqkaz1ng";
    stripRoot = false;
  };

  # anime4k-highend = pkgs.fetchzip {
  #   url = "https://github.com/Tama47/Anime4K/releases/download/v4.0.1/GLSL_Mac_Linux_High-end.zip";
  #   sha256 = "1d50zzqwyh264rbqj3dr9hdylcjs4xbji95hrna5icl3a2fmy7q2"; # nix-preferch-url --unpack hash
  #   stripRoot = false; # Assume multiple files, which requires --unpack hash
  # };
in
{
  options.entertainment.enable = lib.mkEnableOption "enable entertainment modules" // {
    default = false;
  };

  config = lib.mkIf config.entertainment.enable {
    home.packages = [
      # video players and other
      pkgs.ffmpeg-full # just useful for a lot of things

      # music
      pkgs.spotifyd
      (lib.mkIf (!enableSpice) pkgs.spotify)

      # games
      pkgs.prismlauncher
    ];

    # MPV config files
    xdg.configFile = {
      "mpv/mpv.conf".source = "${root}/dotfiles/mpv/mpv.conf";
      "mpv/input.conf".source = "${root}/dotfiles/mpv/input.conf";
      "mpv/scripts/streamDownloader.lua".source = "${root}/dotfiles/mpv/scripts/streamDownloader.lua";
      "mpv/scripts/secondarySubs.lua".source = "${root}/dotfiles/mpv/scripts/secondarySubs.lua";
      "mpv/scripts/simpleSubSync.lua".source = "${root}/dotfiles/mpv/scripts/simpleSubSync.lua";
      "mpv/shaders" = {
        source = "${anime4k-files}/shaders"; # only extracts /shaders folder to not get any of the mpv.conf they provide
      };
      # Necessary font for the modernz script's ui
      "mpv/fonts" = {
        source = "${pkgs.mpvScripts.modernz}/share/fonts";
        recursive = true;
      };
      # Loading config files
      "mpv/script-opts/SimpleHistory.conf".source = "${root}/dotfiles/mpv/script-opts/SimpleHistory.conf";
    };

    programs.mpv = {
      enable = true;

      scripts = with pkgs.mpvScripts; [
        modernz # epic ui
        mpvacious
        thumbfast # thumbnailer preview when hovering progress bar
        autoload # auto load playlist entries for sequential files
        eisa01.smart-copy-paste-2 # paste files into mpv player (subtitles, video)
        eisa01.undoredo # undo/redo time skips
        eisa01.simplehistory
        sponsorblock
      ];

      scriptOpts = {
        simpleSubSync = {
          ffsubsync_bin = "${pkgs.ffsubsync}/bin/ffsubsync";
        };
        modernz = {
          seekbarfg_color = "#FF0032";
          seekbarbg_color = "#555A61";
          hover_effect_color = "#FF0032";
          keeponpause = false; # hide controls when paused on a timer
          window_top_bar = false;
          jump_amount = 3;
          jump_softrepeat = false;
          nibbles_style = "single-bar";
          fade_alpha = 185; # ensures covering the default OSD bar when paused
          fade_blur_strength = 100;
          thumbnail_border_color = "#000000";
          thumbnail_border_outline = "#000000";
          thumbnail_border_radius = 0;
          thumbnail_border = 0;
        };
        subs2srs = {
          use_ffmpeg = true;
          preview_audio = true;
          autoclip = true; # auto turn on clipboard copy
          audio_format = "mp3"; # opus is default
          audio_bitrate = "96k"; # raised from 24k because mp3
          opus_container = "m4a";
          audio_field = "SentenceAudio";
          secondary_field = "SentenceEnglish";
          miscinfo_field = "MiscInfo";
          image_field = "Picture";
          deck_name = "daily decks::mining";
          model_name = "Lapis";
          snapshot_quality = 100;
          snapshot_height = 480;
          animated_snapshot_enabled = true;
          animated_snapshot_quality = 100;
          animated_snapshot_height = 480;
        };
      };
    };

    programs.yt-dlp = {
      enable = true;
      package = pkgs-unstable.yt-dlp;
      settings = {
        write-sub = true;
        write-auto-sub = true;
        sub-lang = "en.*,ja.*";
        sub-format = "vtt"; # format MPV prefers
        cookies-from-browser = "firefox";
        output = "%(title)s.%(ext)s";
      };
    };

    programs.spotify-player = {
      enable = true;
      package = pkgs.spotify-player;
      settings = {
        enable_notify = false;
        enable_media_control = true; # physical keyboard media buttons
        device = {
          volume = 100;
        };
      };
      keymaps = [
        {
          command = "None"; # disable q so that we can leave neovim toggleterm without closing player
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

    # WARNING: On MacOS, spotify will ask you to "update" and it will remove all
    # the spicetify modifications if you say yes. Not sure if there is a good way
    # to stop the update request from appearing yet, haven't experimented much
    programs.spicetify = {
      enable = enableSpice;
      theme = pkgs-spice.themes.lucid; # best theme there is trust
      alwaysEnableDevTools = true; # doesn't work on mac I dont think
      enabledExtensions = with pkgs-spice.extensions; [
        # INFO: nice-to-haves
        shuffle # fischer-yates lets go (ballotery)
        beautifulLyrics # adds epic lyrics with cool fullscreen mode

        # INFO: stats
        songStats # shows song key and other
        # INFO: opinionated
        hidePodcasts # note you can also go to settings and toggle it back and forth

        # lowkey this fullscreen mode looks epic but it kinda overlaps with
        # simpleBeautiful lyrics fullscreen and it feels weird to have two
        # fullScreen # cooler group screen but adds a dupe button
      ];
    };

    home.shellAliases = {
      spt = "spotify_player";
      mpv = "mpv --idle --force-window";
    };
  };
}
