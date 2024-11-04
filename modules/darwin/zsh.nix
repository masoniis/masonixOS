{
  programs.zsh = {
    # To set zsh as default shell must be set by system
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    # Added to (end) of .zprofile
    # INFO:
    # 1st export: Add docker to path, docker desktop isn't on nix I think?
    # 2nd export: Add flutter to path, manually install because using nix on mac wouldn't work
    profileExtra = "
			export PATH=\"$PATH:/Applications/Docker.app/Contents/Resources/bin/\"
			export PATH=$PATH:$HOME/dev/sdk/flutter/bin:$PATH
			export CHROME_EXECUTABLE=\"/Applications/Microsoft Edge Dev.app/Contents/MacOS/Microsoft Edge Dev\"
		";
    # Added to (end) of .zshrc, init zoxide as per docs
    initExtra = "
			eval \"$(zoxide init zsh --cmd cd)\"
		";
  };
}
