{ config, pkgs, ... }:


{
	home.username = "felix";
	home.homeDirectory = "/home/felix";
	programs.git.enable = true;
	home.stateVersion = "25.05";
	home.enableNixpkgsReleaseCheck = false;
}
