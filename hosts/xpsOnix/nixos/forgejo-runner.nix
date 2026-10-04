# a single native (no docker) forgejo actions runner
# workflows target it with `runs-on: native`
#
# forgejo pre-creates the runner (settings -> actions -> runners -> create new runner)
# and hands out a uuid + runner token. the uuid goes in runnerUuid below, the token
# in sops (secrets/default.yaml -> forgejoRunnerToken)
{
  config,
  lib,
  pkgs,
  ...
}:
let
  forgejoUrl = "https://git.knightf6.com";
  runnerName = config.networking.hostName; # name shown in the forgejo ui
  runnerUuid = "3c465d8c-8a12-41f5-8b13-7669e6a6c3b6"; # not secret, shown on the runner's page in forgejo
in
{
  sops.secrets."forgejoRunnerToken" = {
    restartUnits = [ "gitea-runner-main.service" ];
  };
  # unused, the module just requires token or tokenFile to be set
  sops.templates."forgejo-runner.env".content = "";

  services.gitea-actions-runner = {
    # the forgejo-native runner, not gitea's act_runner
    package = pkgs.forgejo-runner;

    instances.main = {
      enable = true;
      name = runnerName;
      url = forgejoUrl;
      tokenFile = config.sops.templates."forgejo-runner.env".path;

      # `native:host` = jobs run directly on the host (no docker)
      labels = [ "native:host" ];

      # PATH for jobs, this is the whole toolbox a native job gets
      # git-lfs for actions/checkout lfs, gnutar + zstd for actions/cache, nodejs for js actions
      hostPackages = with pkgs; [
        config.nix.package # nix client, matches the running daemon
        bash
        coreutils
        curl
        gawk
        gitMinimal
        git-lfs
        gnugrep
        gnused
        gnutar
        nodejs
        openssh
        wget
        zstd
      ];

      settings = {
        runner.capacity = 1; # concurrent jobs
        # connect with the pre-created runner's uuid + token instead of `register`,
        # which only accepts the old one-time registration tokens
        server.connections.knightf6 = {
          url = forgejoUrl;
          uuid = runnerUuid;
          token_url = "file:$CREDENTIALS_DIRECTORY/token";
          labels = [ "native:host" ];
        };
      };
    };
  };

  # static user instead of the module's DynamicUser, which mounts the runner's home
  # (and so every job checkout) noexec and breaks native build scripts / toolchains.
  # the sandboxing DynamicUser would have implied is restated below
  users.users.gitea-runner = {
    isSystemUser = true;
    group = "gitea-runner";
  };
  users.groups.gitea-runner = { };

  systemd.services."gitea-runner-main".serviceConfig = {
    # drop the module's `forgejo-runner register` step, see server.connections above
    ExecStartPre = lib.mkForce [ ];
    # token is exposed to the runner as $CREDENTIALS_DIRECTORY/token
    LoadCredential = [ "token:${config.sops.secrets."forgejoRunnerToken".path}" ];
    DynamicUser = lib.mkForce false;
    ProtectSystem = "strict";
    ProtectHome = "read-only";
    PrivateTmp = true;
    RemoveIPC = true;
    NoNewPrivileges = true;
    RestrictSUIDSGID = true;
  };

  # jobs build through the host nix daemon, so gc when free space gets low
  # instead of waiting on the weekly gc (only unrooted paths are collected)
  nix.settings = {
    min-free = 20 * 1024 * 1024 * 1024;
    max-free = 50 * 1024 * 1024 * 1024;
  };

  # drop per-runner build caches untouched for 14 days
  systemd.tmpfiles.rules = [ "e /var/lib/gitea-runner/*/.cache - - - 14d" ];
}
