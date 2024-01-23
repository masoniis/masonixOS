# NOTE: The default home directory is meant for items that are cross
# platform and global. For project specific installations, I should
# include project-specific flake files.

{ pkgs, username, ... }:
let
	isLinux = pkgs.stdenv.hostPlatform.isLinux;
	isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
	unsupported = builtins.abort "Unsupported platform";
in
{
	# The user account and path that Home Manager will manage
	home.username = "mason";
	home.homeDirectory = 
		if isLinux then "/home/mason" else
		if isDarwin then "/Users/mason" else unsupported;

	#INFO: Import all configs and packages from external files
	imports = [
		./git.nix
		./zsh.nix
		./nvim.nix
		./wezterm.nix
		./packages.nix
		./language.nix
		./starship.nix
  ];

	#WARNING: Don't change this without reading docs
	home.stateVersion = "23.11";
	programs.home-manager.enable = true; # Let home manager manage itself

	# Manage environment (shell) variables
	home.sessionVariables = {
		EDITOR = "nvim";
	};

	fonts.fontconfig.enable = true; # Enable fonts

	nix = { # Configure the Nix package manager itself
		package = pkgs.nix;
		settings.experimental-features = [ "nix-command" "flakes" ];
	};
}
