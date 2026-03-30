{ ... }: {
  # enable signing for just this device
  programs.git = {
    signing = {
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
      format = "ssh";
    };
  };
}
