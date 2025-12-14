{ config, ... }:
{
  nixarr = {
    enable = true;
    mediaDir = "/srv/media_downloads";

    # vpn setup for use by services
    vpn = {
      enable = true;
      wgConf = config.sops.secrets."wgQuickConfiguration".path;
    };

    # INFO: -----------------------
    #         core services
    # -----------------------------

    # essential media services
    jellyfin = {
      enable = true;
      openFirewall = true; # port 8096
      expose.https = {
        enable = false;
        domainName = "jellyfin.masonbott.com";
        acmeMail = "masonmbott@gmail.com";
      };
    };
    jellyseerr = {
      enable = true;
      openFirewall = true; # port 5055
      expose.https = {
        enable = false;
        domainName = "jellyseerr.masonbott.com";
        acmeMail = "masonmbott@gmail.com";
      };
    };
    transmission = {
      enable = true;
      # openFirewall = true; # port 9091
      vpn.enable = true;
      extraSettings = {
        # peer-port = 51413;
        # rpc-bind-address = "0.0.0.0"; # bind to own ip

        # Below only lets host access transmission
        rpc-host-whitelist-enabled = false; # allow any hostname to access
        rpc-whitelist-enabled = false; # allow any ip to access

        rpc-authentication-required = false; # require user/pass (might be useful in future)
        rpc-username = "N/A";
        rpc-password = "N/A";

        # download-dir = "/srv/media_torrents/downloaded";
        # incomplete-dir = "/srv/media_torrents/.incomplete";

        # Seeding and download configs
        ratio-limit-enabled = true;
        download-queue-size = 8;
        ratio-limit = 0.1; # set on show basis with sonarr
      };
    };

    # INFO: -----------------------
    #         *arr services
    # -----------------------------

    sonarr.enable = true;
    radarr.enable = true;
    bazarr.enable = true;
    prowlarr.enable = true;
    recyclarr = {
      enable = true;
      configuration = {
        radarr = {
          movies = {
            base_url = "http://localhost:7878";
            api_key = "!env_var RADARR_API_KEY";
            quality_definition = {
              type = "movie";
            };
            delete_old_custom_formats = true;
            replace_existing_custom_formats = false;
            custom_formats = [
              {
                trash_ids = [
                  "570bc9ebecd92723d2d21500f4be314c" # Remaster
                  "eca37840c13c6ef2dd0262b141a5482f" # 4K Remaster
                ];
                assign_scores_to = [
                  {
                    name = "HD Bluray + WEB";
                    score = 25;
                  }
                ];
              }
            ];
          };
        };
      };
    };
    # sonarr = {
    #   base_url = "http://localhost:8989";
    #   api_key = "!env_var SONARR_API_KEY";
    #
    #   tv = {
    #     quality_profiles = [
    #       "P0"
    #       "P1"
    #       "P2"
    #
    #       "Anime"
    #       "Anime - Absolute"
    #     ];
    #
    #     custom_formats = [ ];
    #
    #     delete_old_custom_formats = false;
    #     replace_existing_custom_formats = false;
    #   };
    # };
  };
}
