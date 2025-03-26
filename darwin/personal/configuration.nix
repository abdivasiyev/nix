{config, pkgs, inputs, lib, ...}:
{
	nixpkgs.config.allowUnfree = true;

	nix = {
		settings = {
			experimental-features = "nix-command flakes";
		};
		gc = {
			automatic = true;
			options = "--delete-older-than 14d";
		};
	};

	system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
	system.stateVersion = 6;
	nixpkgs.hostPlatform = "aarch64-darwin";

	system.activationScripts.postUserActivation.text = ''
		# Following line should allow us to avoid a logout/login cycle
		/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
	'';

	system.keyboard = {
		enableKeyMapping = true;
		remapCapsLockToEscape = true;
	};

	system.defaults.dock = {
		show-recents = false;
		tilesize = 48;
		magnification = true;
	};

	system.defaults.CustomUserPreferences = {
		"com.apple.symbolichotkeys" = {
			AppleSymbolicHotKeys = {
				# Disable 'Cmd + Space' for Spotlight Search
				"64" = {
					enabled = false;
				};
				# Disable 'Cmd + Alt + Space' for Finder search window
				"65" = {
					enabled = false;
				};
			};
		};
		"com.apple.finder" = {
			ShowExternalHardDrivesOnDesktop = false;
			ShowHardDrivesOnDesktop = false;
			ShowMountedServersOnDesktop = false;
			ShowRemovableMediaOnDesktop = false;
			_FXSortFoldersFirst = true;
			# When performing a search, search the current folder by default
			FXDefaultSearchScope = "SCcf";
		};
	};

	fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
	];

	homebrew = {
		enable = true;
		casks = [
			"whisky"
			"obs"
			"ccleaner"
		];
	};
}
