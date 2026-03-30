{ config, ... }: {

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
        enable = true;
        domainName = "jellyseerr.masonbott.com";
        acmeMail = "masonmbott@gmail.com";
      };
    };
    transmission = {
      enable = true;
      flood.enable = true;
      # with vpn on, firewalling doesn't work for local access, using ssh forwarding
      # to access the page on other devices is the best strategy
      vpn.enable = true;
      extraSettings = {
        # below only lets host access transmission
        rpc-host-whitelist-enabled = false; # allow any hostname to access
        rpc-whitelist-enabled = false; # allow any ip to access

        # no user/pass needed since only local host
        rpc-authentication-required = false;
        rpc-username = "N/A";
        rpc-password = "N/A";

        # seeding and download configs
        ratio-limit-enabled = true;
        download-queue-size = 8;
        ratio-limit = 1; # can set on show basis with sonarr
        preallocation =
          2; # (0 = Off, 1 = Fast, 2 = Full (slower but reduces disk fragmentation), default = 1)
      };
    };

    # INFO: -----------------------
    #         *arr services
    # -----------------------------

    sonarr.enable = true;
    radarr.enable = true;
    bazarr.enable = true;
    prowlarr.enable = true;
    autobrr = {
      enable = true;
      settings = {
        checkForUpdates = false;
        host = "0.0.0.0";
        port = 7474;
        logLevel = "DEBUG";
      };
    };
  };
}
