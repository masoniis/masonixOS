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
      ExecStart = "${pkgs.jdk17}/bin/java -Xmx6G -Xms4G -jar server.jar nogui";

      # Data
      User = "minecraft";
      Group = "minecraft";
      WorkingDirectory = "/data/minecraft/astral";
      StateDirectory = "minecraft/astral";

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

  systemd.services.astral-creative = {
    description = "Create Astral Server (creative)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.jdk17}/bin/java -Xmx6G -Xms4G -jar server.jar nogui";

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
