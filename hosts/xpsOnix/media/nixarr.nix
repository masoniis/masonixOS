{ config, ... }:
{
  services.nginx = {
    virtualHosts."_" = {
      default = true;
      rejectSSL = true; # dont try to use SSL for unknown domains, rejects DDNS endpoint for example
      locations."/" = {
        return = "444"; # "no response" (closes connection)
      };
    };
  };

  nixarr = {
    enable = true;
    # this is the default, but leaving it in b/c it is
    # useful to know where all the data is stored
    mediaDir = "/data/media";
    mediaUsers = [ "mason" ];

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
        enable = true;
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
      # with vpn on, firewalling doesn't work for local access, using ssh forwarding
      # to access the page on other devices is the best strategy
      vpn.enable = true;
      extraSettings = {
        # Below only lets host access transmission
        rpc-host-whitelist-enabled = false; # allow any hostname to access
        rpc-whitelist-enabled = false; # allow any ip to access

        rpc-authentication-required = false; # require user/pass (might be useful in future)
        rpc-username = "N/A";
        rpc-password = "N/A";

        # Seeding and download configs
        ratio-limit-enabled = true;
        download-queue-size = 8;
        ratio-limit = 0.1; # set on show basis with sonarr
        preallocation = 2; # (0 = Off, 1 = Fast, 2 = Full (slower but reduces disk fragmentation), default = 1)
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
        # INFO: ---------------------------
        #         config for radarr
        # ---------------------------------
        radarr = {
          movies = {
            # recyclarr instance/config
            base_url = "http://localhost:7878";
            api_key = "!env_var RADARR_API_KEY";

            # naming-style config
            media_naming = {
              folder = "jellyfin-tmdb";
              movie = {
                # rename movies based on the standard below
                rename = true;
                # anime convention is used for all movies since we only have 1 radarr instance
                #
                # anime convention is more verbose than non-anime, so it is the better choice
                # and radarr should be able to handle missing/empty fields for regular movies
                standard = "jellyfin-anime-tmdb";
              };
            };

            # download quality preference
            quality_definition = {
              type = "movie";
            };

            # overarching quality profiles
            quality_profiles = [
              {
                name = "Anime Movie (sub)";
                reset_unmatched_scores.enabled = true;
                upgrade = {
                  allowed = true;
                  until_quality = "Web-1080p";
                };
                min_format_score = 6;
                qualities = [
                  {
                    name = "Raw-HD";
                    enabled = false;
                  }
                  {
                    name = "BR-DISK";
                    enabled = false;
                  }
                  {
                    name = "Remux-2160p";
                    enabled = false;
                  }
                  {
                    name = "Bluray-2160p";
                    enabled = false;
                  }
                  {
                    name = "Web-2160p";
                    qualities = [
                      "WEBDL-2160p"
                      "WEBRip-2160p"
                    ];
                    enabled = false;
                  }
                  {
                    name = "HDTV-2160p";
                    enabled = false;
                  }
                  {
                    name = "Bluray-1080p";
                    qualities = [
                      "Remux-1080p"
                      "Bluray-1080p"
                    ];
                  }
                  {
                    name = "Web-1080p";
                    qualities = [
                      "WEBDL-1080p"
                      "WEBRip-1080p"
                      "HDTV-1080p"
                    ];
                  }
                  {
                    name = "Bluray-720p";
                  }
                  {
                    name = "Web-720p";
                    qualities = [
                      "WEBDL-720p"
                      "WEBRip-720p"
                      "HDTV-720p"
                    ];
                  }
                  {
                    name = "Bluray-576p";
                  }
                  {
                    name = "Bluray-480p";
                  }
                  {
                    name = "Web-480p";
                    qualities = [
                      "WEBDL-480p"
                      "WEBRip-480p"
                    ];
                  }
                  {
                    name = "DVD";
                  }
                  {
                    name = "SDTV";
                  }
                ];
              }
              {
                name = "Anime Movie (dub)";
                reset_unmatched_scores.enabled = true;
                upgrade = {
                  allowed = true;
                  until_quality = "Web-1080p";
                };
                min_format_score = 6;
                qualities = [
                  {
                    name = "Raw-HD";
                    enabled = false;
                  }
                  {
                    name = "BR-DISK";
                    enabled = false;
                  }
                  {
                    name = "Remux-2160p";
                    enabled = false;
                  }
                  {
                    name = "Bluray-2160p";
                    enabled = false;
                  }
                  {
                    name = "Web-2160p";
                    qualities = [
                      "WEBDL-2160p"
                      "WEBRip-2160p"
                    ];
                    enabled = false;
                  }
                  {
                    name = "HDTV-2160p";
                    enabled = false;
                  }
                  {
                    name = "Bluray-1080p";
                    qualities = [
                      "Remux-1080p"
                      "Bluray-1080p"
                    ];
                  }
                  {
                    name = "Web-1080p";
                    qualities = [
                      "WEBDL-1080p"
                      "WEBRip-1080p"
                      "HDTV-1080p"
                    ];
                  }
                  {
                    name = "Bluray-720p";
                  }
                  {
                    name = "Web-720p";
                    qualities = [
                      "WEBDL-720p"
                      "WEBRip-720p"
                      "HDTV-720p"
                    ];
                  }
                  {
                    name = "Bluray-576p";
                  }
                  {
                    name = "Bluray-480p";
                  }
                  {
                    name = "Web-480p";
                    qualities = [
                      "WEBDL-480p"
                      "WEBRip-480p"
                    ];
                  }
                  {
                    name = "DVD";
                  }
                  {
                    name = "SDTV";
                  }
                ];
              }
            ];

            # download format preference
            delete_old_custom_formats = true;
            replace_existing_custom_formats = true;
            custom_formats = [
              {
                # full anime config
                trash_ids = [
                  # List taken in-order from https://trash-guides.info/Radarr/Radarr-collection-of-custom-formats/#anime
                  "fb3ccc5d5cc8f77c9055d4cb4561dded" # Anime BD Tier 01 (Top SeaDex Muxers)
                  "66926c8fa9312bc74ab71bf69aae4f4a" # Anime BD Tier 02 (SeaDex Muxers)
                  "fa857662bad28d5ff21a6e611869a0ff" # Anime BD Tier 03 (SeaDex Muxers)
                  "f262f1299d99b1a2263375e8fa2ddbb3" # Anime BD Tier 04 (SeaDex Muxers)
                  "ca864ed93c7b431150cc6748dc34875d" # Anime BD Tier 05 (Remuxes)
                  "9dce189b960fddf47891b7484ee886ca" # Anime BD Tier 06 (FanSubs)
                  "1ef101b3a82646b40e0cab7fc92cd896" # Anime BD Tier 07 (P2P/Scene)
                  "6115ccd6640b978234cc47f2c1f2cadc" # Anime BD Tier 08 (Mini Encodes)
                  "8167cffba4febfb9a6988ef24f274e7e" # Anime Web Tier 01 (Muxers)
                  "8526c54e36b4962d340fce52ef030e76" # Anime Web Tier 02 (Top FanSubs)
                  "de41e72708d2c856fa261094c85e965d" # Anime Web Tier 03 (Official Subs)
                  "9edaeee9ea3bcd585da9b7c0ac3fc54f" # Anime Web Tier 04 (Official Subs)
                  "22d953bbe897857b517928f3652b8dd3" # Anime Web Tier 05 (FanSubs)
                  "a786fbc0eae05afe3bb51aee3c83a9d4" # Anime Web Tier 06 (FanSubs)
                  "06b6542a47037d1e33b15aa3677c2365" # Anime Raws
                  "b0fdc5897f68c9a68c70c25169f77447" # Anime LQ Groups
                  "064af5f084a0a24458cc8ecd3220f93f" # Uncensored
                  "c259005cbaeb5ab44c06eddb4751e70c" # v0
                  "5f400539421b8fcf71d51e6384434573" # v1
                  "3df5e6dfef4b09bb6002f732bed5b774" # v2
                  "db92c27ba606996b146b57fbe6d09186" # v3
                  "d4e5e842fad129a3c097bdb2d20d31a0" # v4
                  "a5d148168c4506b55cf53984107c396e" # 10bit
                ];
                assign_scores_to = [
                  {
                    name = "Anime Movie (sub)";
                  }
                  {
                    name = "Anime Movie (dub)";
                  }
                ];
              }
              {
                # conditional dual audio format
                trash_ids = [
                  "4a3b087eea2ce012fcc1ce319259a3be" # Anime Dual Audio
                ];
                assign_scores_to = [
                  {
                    name = "Anime Movie (sub)";
                    score = 10; # prefer dual audio if within same tier
                  }
                  {
                    name = "Anime Movie (dub)";
                    score = 2010; # slightly prefer over dubs only
                  }
                ];
              }
              {
                # conditional dubs only format
                trash_ids = [
                  "b23eae459cc960816f2d6ba84af45055" # Dubs Only
                ];
                assign_scores_to = [
                  {
                    name = "Anime Movie (sub)";
                    # keep default which is -10000 when I checked
                  }
                  {
                    name = "Anime Movie (dub)";
                    score = 2000;
                  }
                ];
              }
            ];
          };
        };
        # INFO: ---------------------------
        #         config for sonarr
        # ---------------------------------
        sonarr = {
          shows = {
            # recyclarr instance/config
            base_url = "http://localhost:8989";
            api_key = "!env_var SONARR_API_KEY";

            # naming-style config
            media_naming = {
              season = "default";
              series = "jellyfin-tvdb";
              episodes = {
                rename = true;
                standard = "default";
                daily = "default";
                anime = "default";
              };
            };

            # download quality preference
            quality_definition = {
              type = "series";
            };

            # overarching quality profiles
            quality_profiles = [
              {
                name = "Anime Series (sub)";
                reset_unmatched_scores.enabled = true;
                upgrade = {
                  allowed = true;
                  until_quality = "Web-1080p";
                };
                min_format_score = 6;
                qualities = [
                  {
                    name = "Bluray-2160p Remux";
                    enabled = false;
                  }
                  {
                    name = "Bluray-2160p";
                    enabled = false;
                  }
                  {
                    name = "Web-2160p";
                    qualities = [
                      "WEBDL-2160p"
                      "WEBRip-2160p"
                    ];
                    enabled = false;
                  }
                  {
                    name = "HDTV-2160p";
                    enabled = false;
                  }
                  {
                    name = "Bluray-1080p";
                    qualities = [
                      "Bluray-1080p"
                      "Bluray-1080p Remux"
                    ];
                  }
                  {
                    name = "Web-1080p";
                    qualities = [
                      "WEBDL-1080p"
                      "WEBRip-1080p"
                      "HDTV-1080p"
                    ];
                  }
                  {
                    name = "Bluray-720p";
                  }
                  {
                    name = "Web-720p";
                    qualities = [
                      "WEBDL-720p"
                      "WEBRip-720p"
                      "HDTV-720p"
                    ];
                  }
                  {
                    name = "Bluray-576p";
                  }
                  {
                    name = "Bluray-480p";
                  }
                  {
                    name = "Web-480p";
                    qualities = [
                      "WEBDL-480p"
                      "WEBRip-480p"
                    ];
                  }
                  {
                    name = "DVD";
                  }
                  {
                    name = "SDTV";
                  }
                  {
                    name = "Raw-HD";
                    enabled = false;
                  }
                  {
                    name = "Unknown";
                    enabled = false;
                  }
                ];
              }
              {
                name = "Anime Series (dub)";
                reset_unmatched_scores.enabled = true;
                upgrade = {
                  allowed = true;
                  until_quality = "Web-1080p";
                };
                min_format_score = 6;
                qualities = [
                  {
                    name = "Bluray-2160p Remux";
                    enabled = false;
                  }
                  {
                    name = "Bluray-2160p";
                    enabled = false;
                  }
                  {
                    name = "Web-2160p";
                    qualities = [
                      "WEBDL-2160p"
                      "WEBRip-2160p"
                    ];
                    enabled = false;
                  }
                  {
                    name = "HDTV-2160p";
                    enabled = false;
                  }
                  {
                    name = "Bluray-1080p";
                    qualities = [
                      "Bluray-1080p"
                      "Bluray-1080p Remux"
                    ];
                  }
                  {
                    name = "Web-1080p";
                    qualities = [
                      "WEBDL-1080p"
                      "WEBRip-1080p"
                      "HDTV-1080p"
                    ];
                  }
                  {
                    name = "Bluray-720p";
                  }
                  {
                    name = "Web-720p";
                    qualities = [
                      "WEBDL-720p"
                      "WEBRip-720p"
                      "HDTV-720p"
                    ];
                  }
                  {
                    name = "Bluray-576p";
                  }
                  {
                    name = "Bluray-480p";
                  }
                  {
                    name = "Web-480p";
                    qualities = [
                      "WEBDL-480p"
                      "WEBRip-480p"
                    ];
                  }
                  {
                    name = "DVD";
                  }
                  {
                    name = "SDTV";
                  }
                  {
                    name = "Raw-HD";
                    enabled = false;
                  }
                  {
                    name = "Unknown";
                    enabled = false;
                  }
                ];
              }
            ];

            # download format preference
            delete_old_custom_formats = true;
            replace_existing_custom_formats = true;
            custom_formats = [
              {
                # full anime config (‼️ THESE ARE DIFFERENT FROM RADARR's IDs)
                trash_ids = [
                  # list taken in-order from https://trash-guides.info/Sonarr/sonarr-collection-of-custom-formats/#anime
                  "949c16fe0a8147f50ba82cc2df9411c9" # Anime BD Tier 01 (Top SeaDex Muxers)
                  "ed7f1e315e000aef424a58517fa48727" # Anime BD Tier 02 (SeaDex Muxers)
                  "096e406c92baa713da4a72d88030b815" # Anime BD Tier 03 (SeaDex Muxers)
                  "30feba9da3030c5ed1e0f7d610bcadc4" # Anime BD Tier 04 (SeaDex Muxers)
                  "545a76b14ddc349b8b185a6344e28b04" # Anime BD Tier 05 (Remuxes)
                  "25d2afecab632b1582eaf03b63055f72" # Anime BD Tier 06 (FanSubs)
                  "0329044e3d9137b08502a9f84a7e58db" # Anime BD Tier 07 (P2P/Scene)
                  "c81bbfb47fed3d5a3ad027d077f889de" # Anime BD Tier 08 (Mini Encodes)
                  "e0014372773c8f0e1bef8824f00c7dc4" # Anime Web Tier 01 (Muxers)
                  "19180499de5ef2b84b6ec59aae444696" # Anime Web Tier 02 (Top FanSubs)
                  "c27f2ae6a4e82373b0f1da094e2489ad" # Anime Web Tier 03 (Official Subs)
                  "4fd5528a3a8024e6b49f9c67053ea5f3" # Anime Web Tier 04 (Official Subs)
                  "29c2a13d091144f63307e4a8ce963a39" # Anime Web Tier 05 (FanSubs)
                  "dc262f88d74c651b12e9d90b39f6c753" # Anime Web Tier 06 (FanSubs)
                  "b4a1b3d705159cdca36d71e57ca86871" # Anime Raws
                  "e3515e519f3b1360cbfc17651944354c" # Anime LQ Groups
                  "026d5aadd1a6b4e550b134cb6c72b3ca" # Uncensored
                  "d2d7b8a9d39413da5f44054080e028a3" # v0
                  "273bd326df95955e1b6c26527d1df89b" # v1
                  "228b8ee9aa0a609463efca874524a6b8" # v2
                  "0e5833d3af2cc5fa96a0c29cd4477feb" # v3
                  "4fc15eeb8f2f9a749f918217d4234ad8" # v4
                  "b2550eb333d27b75833e25b8c2557b38" # 10bit
                  # streaming services below (not seen in Radarr config)
                  "3e0b26604165f463f3e8e192261e7284" # CR
                  "89358767a60cc28783cdc3d0be9388a4" # DSNP
                  "d34870697c9db575f17700212167be23" # NF
                  "d660701077794679fd59e8bdf4ce3a29" # AMZN
                  "44a8ee6403071dd7b8a3a8dd3fe8cb20" # VRV
                  "1284d18e693de8efe0fe7d6b3e0b9170" # FUNi
                  "a370d974bc7b80374de1d9ba7519760b" # ABEMA
                  "d54cd2bf1326287275b56bccedb72ee2" # A D N
                  "7dd31f3dee6d2ef8eeaa156e23c3857e" # BGLOBAL
                  "4c67ff059210182b59cdd41697b8cb08" # Bilibili
                  "570b03b3145a25011bf073274a407259" # Hidive
                ];
                assign_scores_to = [
                  {
                    name = "Anime Series (sub)";
                  }
                  {
                    name = "Anime Series (dub)";
                  }
                ];
              }
              {
                # conditional dual audio format
                trash_ids = [
                  "418f50b10f1907201b6cfdf881f467b7" # Anime Dual Audio
                ];
                assign_scores_to = [
                  {
                    name = "Anime Series (sub)";
                    score = 10; # prefer dual audio if within same tier
                  }
                  {
                    name = "Anime Series (dub)";
                    score = 2010; # slightly prefer over dubs only
                  }
                ];
              }
              {
                # conditional dubs only format
                trash_ids = [
                  "9c14d194486c4014d422adc64092d794" # Dubs Only
                ];
                assign_scores_to = [
                  {
                    name = "Anime Series (sub)";
                    # keep default which is -10000 when I checked
                  }
                  {
                    name = "Anime Series (dub)";
                    score = 2000;
                  }
                ];
              }
            ];
          };
        };
      };
    };
  };
}
