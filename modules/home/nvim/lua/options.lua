local opt = vim.opt
-- NEOVIM
opt.termguicolors = true               -- enabled 24 bit RGB color
opt.signcolumn = 'yes'                 -- always draw sign column
opt.updatetime = 50                    -- update time for the swap file and for the cursorHold event
opt.colorcolumn = '120'                -- colorized 80th column
opt.clipboard:append { 'unnamedplus' } -- force to use the clipboard for all the operations

-- BACKUP
opt.swapfile = false                               -- disable the default backup behavior
opt.backup = false                                 -- disable the default backup behavior
opt.undofile = true                                -- activate the undofile behavior
opt.undodir = os.getenv('HOME') .. '/.vim/undodir' -- use the directory of undotree plugin for managing the history

-- FILE LINES
vim.wo.number = true         -- show line number
vim.wo.relativenumber = true -- set line number format to relative
opt.wrap = false             -- wrap lines
opt.scrolloff = 8            -- min nb of line around your cursor (8 above, 8 below)

-- INDENT
opt.smartindent = true -- try to be smart w/ indent
opt.autoindent = true  -- indent new line the same amount as the line before
opt.shiftwidth = 4     -- width for autoindents

-- TAB
opt.expandtab = false -- converts tabs to white space
opt.tabstop = 4       -- nb of space for a tab in the file
opt.softtabstop = 4   -- nb of space for a tab in editing operations

-- SEARCH
opt.ignorecase = true                                      -- case insensitive UNLESS /C or capital in search
opt.hlsearch = true                                        -- highlight all the result found
opt.incsearch = true                                       -- incremental search (show result on live)
opt.wildignore:append { '*/node_modules/*', '*/vendor/*' } -- the search ignore this folder

-- CONTEXTUAL
opt.title = true         -- set the title of the window automaticaly, usefull for tabs plugin
opt.path:append { '**' } -- search (gf or :find) files down into subfolders

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1