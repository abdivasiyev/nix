{config, pkgs, lib, ...}:
{

	home.stateVersion = "25.05";	

	home.packages = with pkgs; [
		jetbrains.datagrip
		raycast
		docker
		colima
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
			plugins = with pkgs.vimPlugins; [
				{
					plugin = telescope-nvim;
					type = "lua";
					config = ''
						local builtin = require('telescope.builtin')

						vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
						vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
						vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
						vim.keymap.set('n', '<leader>cs', builtin.colorscheme, {})
						vim.keymap.set('n', '/', builtin.current_buffer_fuzzy_find, {})
						vim.keymap.set('n', '<leader>gbc', builtin.git_bcommits, {})
						vim.keymap.set('v', '<leader>gbc', builtin.git_bcommits_range, {})
						vim.keymap.set('n', '<leader>gbl', builtin.git_branches, {})
						vim.keymap.set('n', '<leader>gbb', '<cmd>:G blame<cr>')
						vim.keymap.set('n', '<leader>lds', builtin.lsp_document_symbols, {})
						vim.keymap.set('n', '<leader>todo', '<cmd>:TodoTelescope<cr>')
					'';
				}
				{
					plugin = nvim-tree-lua;
					type = "lua";
					config = ''
						-- disable netrw at the very start of your init.lua
						vim.g.loaded_netrw = 1
						vim.g.loaded_netrwPlugin = 1

						-- optionally enable 24-bit colour
						vim.opt.termguicolors = true

						require("nvim-tree").setup({
							sort = {
								sorter = "case_sensitive",
							},
							view = {
								width = 30,
							},
							renderer = {
								group_empty = true,
							},
							filters = {
								dotfiles = true,
							},
							update_focused_file = {
								enable = true,
							},
						})

						vim.keymap.set("n", '<leader><s-p>', ":NvimTreeToggle<CR>")
					'';
				}
			];
			extraLuaConfig = ''
				-- NEOVIM
				vim.opt.termguicolors = true -- enabled 24 bit RGB color
				vim.opt.signcolumn = 'yes' -- always draw sign column
				vim.opt.updatetime = 50 -- update time for the swap file and for the cursorHold event
				vim.opt.colorcolumn = '120' -- colorized 80th column
				vim.opt.clipboard:append { 'unnamedplus' } -- force to use the clipboard for all the operations

				-- BACKUP 
				vim.opt.swapfile = false -- disable the default backup behavior
				vim.opt.backup = false -- disable the default backup behavior
				vim.opt.undofile = true -- activate the undofile behavior
				vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir' -- use the directory of undotree plugin for managing the history

				-- FILE LINES
				vim.wo.number = true -- show line number
				vim.wo.relativenumber = true -- set line number format to relative
				vim.opt.wrap = false -- wrap lines
				vim.opt.scrolloff = 8 -- min nb of line around your cursor (8 above, 8 below)

				-- INDENT
				vim.opt.smartindent = true -- try to be smart w/ indent
				vim.opt.autoindent = true -- indent new line the same amount as the line before
				vim.opt.shiftwidth = 4 -- width for autoindents

				-- TAB
				vim.opt.expandtab = false -- converts tabs to white space
				vim.opt.tabstop = 4 -- nb of space for a tab in the file
				vim.opt.softtabstop = 4 -- nb of space for a tab in editing operations

				-- SEARCH
				vim.opt.ignorecase = true -- case insensitive UNLESS /C or capital in search
				vim.opt.hlsearch = true -- highlight all the result found
				vim.opt.incsearch = true -- incremental search (show result on live)
				vim.opt.wildignore:append { '*/node_modules/*', '*/vendor/*' } -- the search ignore this folder

				-- CONTEXTUAL
				vim.opt.title = true -- set the title of the window automaticaly, usefull for tabs plugin
				vim.opt.path:append { '**' } -- search (gf or :find) files down into subfolders

				vim.g.mapleader = ' '

				-- back to directory tree
				-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

				-- move selection up and down
				vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
				vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

				-- up or down buffer
				vim.keymap.set("n", "<C-d>", "<C-d>zz")
				vim.keymap.set("n", "<C-u>", "<C-u>zz")

				-- exit from terminal mode using <ESC>
				vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")

				-- open terminal in normal mode
				vim.keymap.set("n", "<leader>tt", ":terminal<CR>")

				-- indent selection
				vim.keymap.set("v", "<", "<gv")
				vim.keymap.set("v", ">", ">gv")

				-- switch buffer
				vim.keymap.set("n", "<TAB>", ":bn<CR>")
				vim.keymap.set("n", "<S-TAB>", ":bp<CR>")
				vim.keymap.set("n", "<leader>bd", ":bd<CR>")

				-- show lsp errors on float window
				vim.keymap.set("n", "<leader>e", ":lua vim.diagnostic.open_float(0, {scope='line'})<CR>")
			'';
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
