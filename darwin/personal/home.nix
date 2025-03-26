{config, pkgs, lib, ...}:
{
	home.stateVersion = "25.05";	

	home.packages = with pkgs; [
		jetbrains.datagrip
		raycast
		docker
		colima
		telegram-desktop
		discord
		tree-sitter
		utm
		libgccjit
		ripgrep
	];

	imports = [
		./programs/tmux.nix
		./programs/zsh.nix
		./programs/git.nix
		./programs/nvim.nix
		./programs/alacritty.nix
		./programs/go.nix
	];

	programs.home-manager.enable = true;
}
