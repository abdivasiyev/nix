{config, pkgs, lib, ...}:
{

	home.stateVersion = "25.05";	

	home.packages = with pkgs; [
		jetbrains.datagrip
		raycast
	];

	programs = {
		git = {
			enable = true;
		};
		neovim = {
			enable = true;
		};
		alacritty = {
			enable = true;
		};
		zsh = {
			enable = true;
			oh-my-zsh = {
				enable = true;
				plugins = [
					"git"
				];
				theme = "robbyrussell";
			};
		};
	};

	programs.home-manager.enable = true;
}
