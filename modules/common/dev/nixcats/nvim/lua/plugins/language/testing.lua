return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-java")({
						-- config here
					}),
				},
			})
		end,
		keys = {
			{
				"<leader>rr",
				function()
					require("neotest").run.run()
				end,
				desc = "neotest: Run Nearest",
			},
			{
				"<leader>rf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "neotest: Run File",
			},
			{
				"<leader>rs",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "neotest: Summary",
			},
			{
				"<leader>ro",
				function()
					require("neotest").output.open({ enter = true })
				end,
				desc = "neotest: Output",
			},
			{
				"<leader>rS",
				function()
					require("neotest").run.stop()
				end,
				desc = "neotest: Stop",
			},
			{
				"<leader>rw",
				function()
					require("neotest").watch.toggle()
				end,
				desc = "neotest: Toggle watch for file",
			},
		},
	},
	{
		"rcasia/neotest-java",
		ft = "java",
		dependencies = {
			"mfussenegger/nvim-jdtls",
			"mfussenegger/nvim-dap", -- for the debugger
			"rcarriga/nvim-dap-ui", -- recommended
			"theHamsta/nvim-dap-virtual-text", -- recommended
		},
	},
}
