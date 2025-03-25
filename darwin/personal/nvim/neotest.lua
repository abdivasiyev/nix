local neotest = require('neotest')
local coverage = require('coverage')

coverage.setup({
	auto_reload = true,
})

neotest.setup({
	adapters = {
		require('neotest-golang')({
			runner = "go",
			go_test_args = {
				"-v",
				"-race",
				"-count=1",
				"-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
			},
		}),
	},
})

vim.keymap.set('n', "<leader>ta", function() neotest.run.attach() end)
vim.keymap.set('n', "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end)
vim.keymap.set('n', "<leader>tA", function() neotest.run.run(vim.uv.cwd()) end)
vim.keymap.set('n', "<leader>tS", function() neotest.run.run({ suite = true }) end)
vim.keymap.set('n', "<leader>tn", function() neotest.run.run() end)
vim.keymap.set('n', "<leader>tl", function() neotest.run.run_last() end)
vim.keymap.set('n', "<leader>ts", function() neotest.summary.toggle() end)
vim.keymap.set('n', "<leader>to", function() neotest.output.open({ enter = true, auto_close = true }) end)
vim.keymap.set('n', "<leader>tO", function() neotest.output_panel.toggle() end)
vim.keymap.set('n', "<leader>tp", function() neotest.run.stop() end)
vim.keymap.set('n', "<leader>td", function() neotest.run.run({ suite = false, strategy = "dap" }) end)
vim.keymap.set('n', "<leader>tD", function() neotest.run.run({ vim.fn.expand("%"), strategy = "dap" }) end)
vim.keymap.set('n', "<leader>tc", ":Coverage<cr>:CoverageSummary<cr>")
