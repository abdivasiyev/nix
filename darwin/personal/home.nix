{config, pkgs, lib, ...}:
{

	home.stateVersion = "25.05";	

	home.packages = with pkgs; [
		jetbrains.datagrip
		raycast
		docker
	];

	programs = {
		tmux = {
			enable = true;
			keyMode = "vi";
			extraConfig = ''
				# Use Alt-arrow keys to switch panes
				bind -n M-Left select-pane -L
				bind -n M-Right select-pane -R
				bind -n M-Up select-pane -U
				bind -n M-Down select-pane -D

				# Shift arrow to switch windows
				bind -n S-Left previous-window
				bind -n S-Right next-window

				# Enable vi copy mode
				setw -g mode-keys vi

				# Set new panes to open in current directory
				bind c new-window
				bind '"' split-window
				bind % split-window -h



			'';
			plugins = with pkgs; [
				tmuxPlugins.yank
				tmuxPlugins.resurrect
				{
					plugin = tmuxPlugins.rose-pine;
					extraConfig = ''
						set -g @rose_pine_variant 'moon' # Options are 'main', 'moon' or 'dawn'
						set -g @rose_pine_host 'on' # Enables hostname in the status bar
						set -g @rose_pine_user 'on' # Turn on the username component in the statusbar
						set -g @rose_pine_directory 'on' # Turn on the current folder component in the status bar

						set -g @rose_pine_only_windows 'on' # Leaves only the window module, for max focus and space
						set -g @rose_pine_disable_active_window_menu 'on' # Disables the menu that shows the active window on the left

						set -g @rose_pine_show_current_program 'on' # Forces tmux to show the current running program as window name

						# Example values for these can be:
						set -g @rose_pine_left_separator ' > ' # The strings to use as separators are 1-space padded
						set -g @rose_pine_right_separator ' < ' # Accepts both normal chars & nerdfont icons
						set -g @rose_pine_field_separator ' | ' # Again, 1-space padding, it updates with prefix + I
						set -g @rose_pine_window_separator ' - ' # Replaces the default `:` between the window number and name

						# These are not padded
						set -g @rose_pine_session_icon '' # Changes the default icon to the left of the session name
						set -g @rose_pine_current_window_icon '' # Changes the default icon to the left of the active window name
						set -g @rose_pine_folder_icon '' # Changes the default icon to the left of the current directory folder
						set -g @rose_pine_username_icon '' # Changes the default icon to the right of the hostname
						set -g @rose_pine_hostname_icon '󰒋' # Changes the default icon to the right of the hostname
						set -g @rose_pine_date_time_icon '󰃰' # Changes the default icon to the right of the date module
						set -g @rose_pine_window_status_separator "  " # Changes the default icon that appears between window names
					'';
				}
			];
		};
		git = {
			enable = true;
			userName = "Asliddin Abdivasiyev";
			userEmail = "asliddin.abdivasiyev@gmail.com";
		};
		neovim = {
			enable = true;
			defaultEditor = true;
			viAlias = true;
			vimAlias = true;
			vimdiffAlias = true;
		};
		alacritty = {
			enable = true;
			settings = {
				window = {
					startup_mode = "Fullscreen";
				};
				font = {
					normal.family = "JetBrainsMono Nerd Font";
					bold.family = "JetBrainsMono Nerd Font";
					italic.family = "JetBrainsMono Nerd Font";
					bold_italic.family = "JetBrainsMono Nerd Font";
					size = 20;
				};
			};
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
