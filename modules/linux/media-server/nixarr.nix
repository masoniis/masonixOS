{ config, ... }:
{
  nixarr = {
    enable = true;
    mediaDir = "/data/media"; # default media dir, still specified to be explicit
    mediaUsers = [ "mason" ];

    # vpn setup for media services, relies on a wireguard config secret in sops
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
    seerr = {
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
      peerPort = 51413; # set explicitly to avoid upstream nixarr error with null peerPort
      flood.enable = true;
      # with vpn on, firewalling doesn't work for local access, using ssh forwarding
      # to access the page on other devices is the best replacemen strategy
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
        ratio-limit = 0; # should be set on show basis with *arr stack
        preallocation = 2; # (0 = Off, 1 = Fast, 2 = Full (slower but reduces disk fragmentation), default = 1)
      };
    };

    # INFO: -----------------------
    #         *arr services
    # -----------------------------

    sonarr = {
      enable = true;
      openFirewall = true; # port 8989
    };
    radarr = {
      enable = true;
      openFirewall = true; # port 7878
    };
    bazarr = {
      enable = true;
      openFirewall = true; # port 6767
    };
    prowlarr = {
      enable = true;
      openFirewall = true; # port 9696
    };
    autobrr = {
      enable = true;
      openFirewall = true; # port 7474
      settings = {
        checkForUpdates = false;
        host = "0.0.0.0";
        port = 7474;
        logLevel = "DEBUG";
      };
    };
  };
}
