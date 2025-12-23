{
  # Service responsible for banning IPs that appear to have malicious intent
  #
  # Especially useful for jellyfin, since the jellyfin login portal has no rate limiting
  # or login attempt limits set otherwise.
  services.fail2ban = {
    enable = true;
    bantime = "1h";
    bantime-increment.enable = true;

    jails = {
      # jail generic botsearch (ie people scanning vulnerability routes like /admin.php)
      nginx-botsearch = {
        settings = {
          enabled = true;
          backend = "systemd";
        };
      };

      # jail for too many jellyfin login fails
      jellyfin = {
        settings = {
          enabled = true;
          filter = "jellyfin";
          backend = "systemd";
          maxretry = 5;
        };
      };

      # jail for too many jellyseerr login fails
      jellyseerr = {
        settings = {
          enabled = true;
          filter = "jellyseerr";
          backend = "systemd";
          maxretry = 5;
        };
      };
    };
  };

  # filter for IP address of jellyfin login failures, example log in line ⬇️:
  # [17:51:27] [INF] [77] Jellyfin.Server.Implementations.Users.UserManager: Authentication request for <USER> has been denied (IP: <ADDR>).
  environment.etc."fail2ban/filter.d/jellyfin.conf".text = ''
    [Definition]
    failregex = ^.*Authentication request for .* has been denied \(IP: <ADDR>\)\.
    journalmatch = _SYSTEMD_UNIT=jellyfin.service
  '';

  # filter for IP address of jellyseerr "login with jellyfin" failures, example log line ⬇️
  # 2025-12-25T00:54:23.364Z [warn][Auth]: Failed login attempt from user with incorrect Jellyfin credentials {"account":{"ip":"<ADDR>","email":"<USER>","password":"__REDACTED__"}}
  environment.etc."fail2ban/filter.d/jellyseerr.conf".text = ''
    [Definition]
    failregex = ^.*Failed login attempt.*"ip"\s*:\s*"<ADDR>"
    journalmatch = _SYSTEMD_UNIT=jellyseerr.service
  '';
}
