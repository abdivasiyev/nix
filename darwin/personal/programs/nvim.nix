{pkgs, ...}:
{
	programs.neovim = {
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
}
