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

    # essential media service/#/login.html?serverid=79d8602d7fcc40e8b9ffad653eacf7d4s
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
        enable = true;
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

        download-dir = "/srv/media_torrents/downloaded";
        incomplete-dir = "/srv/media_torrents/.incomplete";

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
      configFile = "./recyclarr.yaml";
    };
  };
}
