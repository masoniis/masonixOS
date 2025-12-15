{
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

      # jail many jellyfin login fails
      jellyfin = {
        settings = {
          enabled = true;
          filter = "jellyfin";
          backend = "systemd";
          maxretry = 5;
        };
      };
    };
  };

  # filter for jellyfin jail
  environment.etc."fail2ban/filter.d/jellyfin.conf".text = ''
    [Definition]
    failregex = ^.*Authentication request for .* has been denied \(IP: <HOST>\)\.
    journalmatch = _SYSTEMD_UNIT=jellyfin.service
  '';
}
