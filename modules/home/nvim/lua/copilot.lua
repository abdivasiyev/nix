require('copilot').setup({
	suggestion = {
		enabled = true,
	},
})

vim.keymap.set("i", "<C-J>", function() require("copilot.suggestion").accept() end)
vim.keymap.set("i", "<C-H>", function() require("copilot.suggestion").previous() end)
vim.keymap.set("i", "<C-L>", function() require("copilot.suggestion").next() end)
vim.keymap.set("i", "<C-\\>", function() require("copilot.suggestion").dismiss() end)
