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

-- CocLists for IDE-like functionality
vim.keymap.set("n", "<leader>d", ":CocList diagnostics<CR>", { silent = true, desc = "Diagnostics" })
vim.keymap.set("n", "<leader>c", ":CocList commands<CR>", { silent = true, desc = "Commands" })
vim.keymap.set("n", "<leader>a", ":CocList actions<CR>", { silent = true, desc = "Actions" })
vim.keymap.set("n", "<leader>o", ":CocList outline<CR>", { silent = true, desc = "Outline" })
vim.keymap.set("n", "<leader>r", ":CocList references<CR>", { silent = true, desc = "References" })

-- Scroll floating windows (like docs, code actions)
vim.keymap.set("n", "<C-f>", function()
  return vim.fn["coc#float#has_scroll"]() == 1 and "<C-r>=coc#float#scroll(1)<CR>" or "<C-f>"
end, { silent = true, expr = true })

vim.keymap.set("n", "<C-b>", function()
  return vim.fn["coc#float#has_scroll"]() == 1 and "<C-r>=coc#float#scroll(0)<CR>" or "<C-b>"
end, { silent = true, expr = true })

-- Trigger completion (like VSCode Ctrl-Space)
vim.keymap.set("i", "<C-Space>", "coc#refresh()", { expr = true, silent = true, desc = "Trigger completion" })

-- Helper function to check for words before cursor
local function check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Tab: next completion item or insert tab
vim.keymap.set("i", "<Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return vim.fn["coc#_select_confirm"]() == 0 and "<C-n>" or "<C-n>"
  elseif check_back_space() then
    return "<Tab>"
  else
    return vim.fn["coc#refresh"]()
  end
end, { expr = true, silent = true })

-- Shift-Tab: previous completion item
vim.keymap.set("i", "<S-Tab>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
  else
    return "<C-h>"
  end
end, { expr = true, silent = true })

-- Enter: confirm selected item or fallback
vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    return vim.fn["coc#pum#confirm"]()
  else
    return "<CR>"
  end
end, { expr = true, silent = true })
