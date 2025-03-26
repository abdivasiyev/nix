{pkgs, lib, ...}:
{
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;
		plugins = with pkgs.vimPlugins; [
			nvim-web-devicons
			{
				plugin = telescope-nvim;
				type = "lua";
				config = builtins.readFile(../dotfiles/nvim/telescope.lua);
			}
			{
				plugin = nvim-tree-lua;
				type = "lua";
				config = builtins.readFile(../dotfiles/nvim/nvim-tree.lua);
			}
			nvim-treesitter
			neotest-golang
			plenary-nvim
			FixCursorHold-nvim
			nvim-coverage
			## debugging
			nvim-dap
			nvim-nio
			nvim-dap-virtual-text
			nvim-dap-go
			{
				plugin = nvim-dap-ui;
				type = "lua";
				config = builtins.readFile(../dotfiles/nvim/dap.lua);
			}
			{
				plugin = neotest;
				type = "lua";
				config = builtins.readFile(../dotfiles/nvim/neotest.lua);
			}
			coc-clangd
			coc-go
			coc-yaml
			coc-lua
			coc-sh
			{
				plugin = pkgs.vimUtils.buildVimPlugin {
					pname = "cyberdream.nvim";
					version = "main"; # Use a commit hash for stability
					src = pkgs.fetchFromGitHub {
						owner = "scottmckendry";
						repo = "cyberdream.nvim";
						rev = "main";
						sha256 = "sha256-ty7F9v2fm6lUsn+QiL31PWm5w4VVr4rFgNOMjLxyoeY=";
					};
				};
				type = "lua";
				config = "vim.cmd.colorscheme \"cyberdream\"";
			}
			undotree
			{
				plugin = copilot-lua;
				type = "lua";
				config = "require(\"copilot\").setup{}";
			}
			vim-wakatime
			vim-fugitive
			vim-visual-multi
			{
				plugin = leetcode-nvim;
				type = "lua";
				config = ''
					local leet = require('leetcode');
					leet.setup {
						storage = {
								home = '~/Development/competitive/leetcode',
						}
					}
					vim.keymap.set('n', '<leader>lt', ':Leet test<cr>')
				'';
			}
			{
				plugin = gitsigns-nvim;
				type = "lua";
				config = "require(\"gitsigns\").setup{}";
			}
			{
				plugin = fidget-nvim;
				type = "lua";
				config = "require(\"fidget\").setup{}";
			}
			{
				plugin = which-key-nvim;
				type = "lua";
				config = "require(\"which-key\").setup{}";
			}
		];
		extraLuaConfig = builtins.readFile(../dotfiles/nvim/base-config.lua);

		coc = {
			enable = true;
		};
	};
}
