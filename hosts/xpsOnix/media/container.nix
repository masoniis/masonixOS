{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  # INFO: Forward host interface to containers or something
  # Source: https://nixos.org/manual/nixos/stable/#sec-container-networking
  networking.networkmanager.unmanaged = [ "interface-name:ve-*" ];
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ]; # wildcard for all container interfaces
    externalInterface = "wlp59s0"; # host interface
  };

  environment.systemPackages = [ pkgs.ncdu ];

  # Create media dir for container to bind to
  systemd.tmpfiles.rules = [
    "d /srv/media_downloads 0777 root root -"
    "d /srv/media_torrents 0777 root root -"
  ];

  containers.media = {
    bindMounts = {
      "/srv/media" = {
        hostPath = "/srv/media_downloads"; # bind media to host for ez access
        isReadOnly = false;
      };
      "/srv/transmission" = {
        hostPath = "/srv/media_torrents"; # bind transmission dir to host
        isReadOnly = false;
      };
    };

    autoStart = false; # autostart dangerous if low storage

    enableTun = true;
    privateNetwork = true;
    hostAddress = "192.168.10.1";
    localAddress = "192.168.10.2";

    forwardPorts =
      let
        tcpPorts = [
          9091 # Transmission (Web UI)
          8096 # Jellyfin
          5055 # Jellyseerr
          8989 # Sonarr
          7878 # Radarr
          6767 # Bazarr
          9696 # Prowlarr
        ];

        udpPorts = [
          51413 # Transmission (Peer Port)
        ];

        # Helper function that creates the port mapping structure from
        # container port to the corresponding identical host port
        mkPort = proto: port: {
          containerPort = port;
          hostPort = port;
          protocol = proto;
        };

      in
      # Generates the port config using vars above
      (lib.map (mkPort "tcp") tcpPorts) ++ (lib.map (mkPort "udp") udpPorts);

    config = {
      environment.systemPackages = with pkgs; [
        dnsutils
        jellyfin
        jellyfin-web
        jellyfin-ffmpeg
        tcpdump
        acl
      ];
      system.stateVersion = "24.11";

      # Networking
      networking = {
        dhcpcd.enable = false;
        useHostResolvConf = false;
        # Container needs to send traffic through the host
        # when communicating with local network devices...
        # That's what this does ->
        interfaces."eth0".ipv4.routes = [
          {
            address = "192.168.1.0";
            prefixLength = 24;
            via = "192.168.10.1";
          }
          {
            address = "192.168.68.0";
            prefixLength = 24;
            via = "192.168.10.1";
          }
        ];
        # firewall to prevent leaks outside of vpn by only accepting marked traffic
        firewall = {
          enable = true;
          allowedUDPPorts = [
            1194 # ovpn standard port
            51413 # transmission peer port, do i need?
          ];
          # tcp ports for *arr serviecs are already implicitly
          # allowed due to settings 'openFirewall = true'

          # Reject all traffic not going through VPN
          extraCommands = ''
            # Allow loopback and initial VPN connection
            iptables -A OUTPUT -o lo -j ACCEPT
            iptables -A OUTPUT -p udp --dport 1194 -j ACCEPT
            iptables -A OUTPUT -m addrtype --dst-type MULTICAST -j ACCEPT

            # Allow traffic to the host over container interface
            iptables -A OUTPUT -d 192.168.10.1 -o ve-+ -j ACCEPT

            # Allow established/related connections
            iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

            # Mark packets going through tun0 (VPN interface)
            iptables -t mangle -A OUTPUT -o tun0 -j MARK --set-mark 0x1234

            # Allow marked traffic
            iptables -A OUTPUT -m mark --mark 0x1234 -j ACCEPT

            # Reject everything else
            iptables -A OUTPUT -j REJECT
          '';
        };
      };

      # VPN service
      services.openvpn.servers.mediaVPN = {
        updateResolvConf = true;
        authUserPass.username = lib.removeSuffix "\n" (builtins.readFile ./nordUser.key);
        authUserPass.password = lib.removeSuffix "\n" (builtins.readFile ./nordPass.key);
        # udp config from https://my.nordaccount.com/dashboard/nordvpn/manual-configuration/openvpn/
        config = builtins.readFile ./nordvpn.com.udp.ovpn.key;
      };

      nixpkgs.config.permittedInsecurePackages = [
        "aspnetcore-runtime-wrapped-6.0.36"
        "aspnetcore-runtime-6.0.36"
        "dotnet-sdk-wrapped-6.0.428"
        "dotnet-sdk-6.0.428"
      ];

      # Media group, dir perms, and file tree structure
      users.groups.media.members = [
        "jellyfin"
        "sonarr"
        "radarr"
        "transmission"
        "bazarr"
      ];
      systemd.tmpfiles.rules = [
        "d /srv/media 2775 root media -"
        "d /srv/media/shows 2775 root media -"
        "d /srv/media/anime 2775 root media -"
        "d /srv/media/movies  2775 root media -"
        "d /srv/transmission 2775 root media -"
        "d /srv/transmission/.incomplete 2775 root media -"
        "d /srv/transmission/downloaded 2775 root media -"
        "d /srv/transmission/downloaded/sonarr 2775 root media -"
        "d /srv/transmission/downloaded/radarr 2775 root media -"
        "d /srv/anisyncache 2775 root media -"
        "z /srv/media 2775 root media -"
        "z /srv/media/shows 2775 root media -"
        "z /srv/media/anime 2775 root media -"
        "z /srv/media/movies  2775 root media -"
        "z /srv/transmission 2775 root media -"
        "z /srv/transmission/.incomplete 2775 root media -"
        "z /srv/transmission/downloaded 2775 root media -"
        "z /srv/transmission/downloaded/sonarr 2775 root media -"
        "z /srv/transmission/downloaded/radarr 2775 root media -"
        "z /srv/anisyncache 2775 root media -"
      ];
      # Set up ACLs for inheritance
      system.activationScripts.mediaPermissions = {
        text = ''
          echo "Setting up ACLs for media directories..."
          ${pkgs.acl}/bin/setfacl -R -m g:media:rwx /srv/media /srv/transmission /srv/anisyncache
          ${pkgs.acl}/bin/setfacl -R -d -m g:media:rwx /srv/media /srv/transmission /srv/anisyncache
        '';
        deps = [ ];
      };

      services.jellyfin = {
        enable = true;
        openFirewall = true; # port 8096
        group = "media";
        user = "jellyfin";
      };

      services.jellyseerr = {
        enable = true;
        openFirewall = true; # port 5055
        # jellyseer has no group/user option
      };

      services.sonarr = {
        enable = true;
        openFirewall = true; # port 8989
        group = "media";
        user = "sonarr";
      };

      services.radarr = {
        enable = true;
        openFirewall = true; # port 7878
        group = "media";
        user = "radarr";
      };

      services.bazarr = {
        enable = true;
        openFirewall = true; # port 6767
        group = "media";
        user = "bazarr";
      };

      services.prowlarr = {
        enable = true;
        openFirewall = true; # port 9696
        package = pkgs-unstable.prowlarr;
      };

      # Settings available at https://github.com/transmission/transmission/blob/main/docs/Editing-Configuration-Files.md
      services.transmission = {
        enable = true; # Enable transmission daemon
        openFirewall = true; # port 9091
        openRPCPort = true; # opens firewall for RPC
        package = pkgs.transmission_4-qt;
        group = "media";
        user = "transmission";
        settings = {
          peer-port = 51413;
          unmask = 2; # set write perms for other groups
          rpc-bind-address = "0.0.0.0"; # bind to own ip

          # Below only lets host access transmission
          rpc-host-whitelist-enabled = false; # allow any hostname to access
          rpc-whitelist-enabled = false; # allow any ip to access

          rpc-authentication-required = false; # require user/pass (might be useful in future)
          rpc-username = "N/A";
          rpc-password = "N/A";

          download-dir = "/srv/transmission/downloaded";
          incomplete-dir = "/srv/transmission/.incomplete";
          # Seeding and download configs
          ratio-limit-enabled = true;
          download-queue-size = 8;
          ratio-limit = 0.1; # set on show basis with sonarr
        };
      };

      # Hack to get transmission proper directory rights to mount
      systemd.services.transmission.serviceConfig = {
        RootDirectoryStartOnly = lib.mkForce false;
        RootDirectory = lib.mkForce "";
      };
    };
  };
}
