-- ==============================
-- Coc.nvim IDE-like keybindings
-- ==============================

-- Diagnostic navigation
vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true, desc = "Prev diagnostic" })
vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true, desc = "Next diagnostic" })

-- Go to navigation
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true, desc = "Go to definition" })
vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true, desc = "Go to type definition" })
vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true, desc = "Go to implementation" })
vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true, desc = "Go to references" })

-- Show documentation on hover
function _G.show_docs()
	local cw = vim.fn.expand("<cword>")
	if vim.fn.CocAction("hasProvider", "hover") then
		vim.fn.CocActionAsync("doHover")
	else
		vim.cmd("!" .. vim.o.keywordprg .. " " .. cw)
	end
end

vim.keymap.set("n", "K", _G.show_docs, { silent = true, desc = "Hover documentation" })

-- Symbol renaming
vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", { silent = true, desc = "Rename symbol" })

-- Code actions
vim.keymap.set("n", "<leader>ca", "<Plug>(coc-codeaction)", { silent = true, desc = "Code action" })
vim.keymap.set("x", "<leader>ca", "<Plug>(coc-codeaction-selected)", { silent = true, desc = "Code action (selected)" })
vim.keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current)", { silent = true, desc = "Quick fix" })

-- Refactorings
vim.keymap.set("n", "<leader>re", "<Plug>(coc-refactor)", { silent = true, desc = "Refactor" })

-- Show diagnostics / outline
vim.keymap.set("n", "<leader>e", ":CocDiagnostics<CR>", { silent = true, desc = "Diagnostics list" })
vim.keymap.set("n", "<leader>o", ":CocOutline<CR>", { silent = true, desc = "Symbol outline" })

-- Show workspace symbols
vim.keymap.set("n", "<leader>s", ":CocList -I symbols<CR>", { silent = true, desc = "Search workspace symbols" })

-- Helper function to check backspace
local function check_back_space()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Convert string into termcodes
local function replace_termcodes(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- Select next item on <Tab>
vim.keymap.set('i', "<Tab>", function()
	if vim.fn["coc#pum#visible"]() == 1 then
		return vim.fn["coc#pum#next"](1)
	elseif check_back_space() then
		return replace_termcodes("<Tab>")
	else
		vim.fn["coc#refresh"]()
		return ""
	end
end, { expr = true, silent = true })

-- Select prev item on <S-Tab>
vim.keymap.set('i', "<S-Tab>", function()
	if vim.fn["coc#pum#visible"]() == 1 then
		return vim.fn["coc#pum#prev"](1)
	else
		return replace_termcodes("<C-h>")
	end
end, { expr = true, silent = true })

-- Confirm on <CR>
vim.keymap.set('i', "<CR>", function()
	if vim.fn["coc#pum#visible"]() == 1 then
		return vim.fn["coc#pum#confirm"]()
	else
		return replace_termcodes("<CR>")
	end
end, { expr = true, silent = true })
