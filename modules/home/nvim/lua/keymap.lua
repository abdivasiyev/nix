vim.g.mapleader = ' '
vim.g.localleader = '  '

local keymap = vim.keymap

-- move selection up and down
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- exit from terminal mode using <ESC>
keymap.set("t", "<ESC>", "<C-\\><C-n>")

-- open terminal in normal mode
keymap.set("n", "<leader>tt", ":terminal<CR>")

-- indent selection
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- switch buffer
keymap.set("n", "<TAB>", ":bn<CR>")
keymap.set("n", "<S-TAB>", ":bp<CR>")