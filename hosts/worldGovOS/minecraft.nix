{ pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    25565
    25566
  ];

  users.users.minecraft = {
    isSystemUser = true;
    group = "minecraft";
    home = "/data/minecraft";
    createHome = true;
  };
  users.groups.minecraft = { };

  systemd.services.astral = {
    description = "Create Astral Server";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStartPre =
        let
          configTemplate = pkgs.writeText "lazymc.toml" ''
            [config]
            version = "0.2.7" # https://github.com/timvisee/lazymc/blob/fba581d4bd531e6616158cb2231d4c7b69f443a0/res/lazymc.toml

            [public]
            version = "1.18.2" # version sent to clients
            address = "0.0.0.0:25565" # external port lazymc uses as a proxy to the MC server

            [server]
            address = "127.0.0.1:25545" # internal port of actual MC server
            command = "${pkgs.jdk17}/bin/java -Xmx6G -Xms4G -jar server.jar nogui"

            [time]
            sleep_after = 7200 # sleep server if 0 players remain
            minimum_online_time = 60 # sleep if starts up but no one joins (bots, perhaps)

            [rcon]
            # this allows LazyMC to ask the server who is on and stuff
            enabled = true
            port = 25575
            randomize_password = true

            [advanced]
            rewrite_server_properties = true # lazymc updates properties with rcon password, ports, etc
          '';
        in
        "${pkgs.bash}/bin/bash -c 'cp -f ${configTemplate} /data/minecraft/astral/lazymc.toml && chmod +w /data/minecraft/astral/lazymc.toml'";

      ExecStart =
        let
          # lazymc is very specific to mc version, this one works with the version the astral server runs on (1.18.2)
          lazymcOld = pkgs.stdenv.mkDerivation {
            pname = "lazymc-static";
            version = "0.2.7";
            src = pkgs.fetchurl {
              url = "https://github.com/timvisee/lazymc/releases/download/v0.2.7/lazymc-v0.2.7-linux-x64-static";
              sha256 = "sha256-GePm/cjyFNMF5x3eXa1QkEHfyIRAmlswerhPKFX/HTA=";
            };
            dontUnpack = true;
            installPhase = ''
              mkdir -p $out/bin
              cp $src $out/bin/lazymc
              chmod +x $out/bin/lazymc
            '';
          };
        in
        "${lazymcOld}/bin/lazymc --config /data/minecraft/astral/lazymc.toml start";

      # Data
      User = "minecraft";
      Group = "minecraft";
      WorkingDirectory = "/data/minecraft/astral";
      StateDirectory = "minecraft/astral";

      # Startup/restart handling
      TimeoutStopSec = "1500";
      Restart = "on-failure";
      RestartSec = "20s";

      # Allow Lazymc to bind ports
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";

      # Security
      ProtectSystem = "full";
      PrivateTmp = true;
      ProtectHome = true;
    };
  };

  systemd.services.astral-creative = {
    description = "Create Astral Server (creative)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStartPre =
        let
          configTemplate = pkgs.writeText "lazymc.toml" ''
            [config]
            version = "0.2.7" # https://github.com/timvisee/lazymc/blob/fba581d4bd531e6616158cb2231d4c7b69f443a0/res/lazymc.toml

            [public]
            version = "1.18.2" # version sent to clients
            address = "0.0.0.0:25566" # external port lazymc uses as a proxy to the MC server

            [server]
            address = "127.0.0.1:25546" # internal port of actual MC server
            command = "${pkgs.jdk17}/bin/java -Xmx6G -Xms4G -jar server.jar nogui"

            [time]
            sleep_after = 7200 # sleep server if 0 players remain
            minimum_online_time = 60 # sleep if starts up but no one joins (bots, perhaps)

            [rcon]
            # this allows LazyMC to ask the server who is on and stuff
            enabled = true
            port = 25576
            randomize_password = true

            [advanced]
            rewrite_server_properties = true # lazymc updates properties with rcon password, ports, etc
          '';
        in
        "${pkgs.bash}/bin/bash -c 'cp -f ${configTemplate} /data/minecraft/astral-creative/lazymc.toml && chmod +w /data/minecraft/astral-creative/lazymc.toml'";

      ExecStart =
        let
          # lazymc is very specific to mc version, this one works with the version the astral server runs on (1.18.2)
          lazymcOld = pkgs.stdenv.mkDerivation {
            pname = "lazymc-static";
            version = "0.2.7";
            src = pkgs.fetchurl {
              url = "https://github.com/timvisee/lazymc/releases/download/v0.2.7/lazymc-v0.2.7-linux-x64-static";
              sha256 = "sha256-GePm/cjyFNMF5x3eXa1QkEHfyIRAmlswerhPKFX/HTA=";
            };
            dontUnpack = true;
            installPhase = ''
              mkdir -p $out/bin
              cp $src $out/bin/lazymc
              chmod +x $out/bin/lazymc
            '';
          };
        in
        "${lazymcOld}/bin/lazymc --config /data/minecraft/astral-creative/lazymc.toml start";

      # Data
      User = "minecraft";
      Group = "minecraft";
      WorkingDirectory = "/data/minecraft/astral-creative";
      StateDirectory = "minecraft/astral-creative";

      # Startup/restart handling
      TimeoutStopSec = "1500"; # give ~15 minutes before force killing on a shutdown
      Restart = "on-failure";
      RestartSec = "20s";

      # Security
      ProtectSystem = "full";
      PrivateTmp = true;
      ProtectHome = true;
    };
  };
}
