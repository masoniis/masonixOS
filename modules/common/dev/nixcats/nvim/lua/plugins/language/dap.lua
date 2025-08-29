return {
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<leader>db",
				"<cmd>lua require'dap'.toggle_breakpoint()<cr>",
				desc = "toggle breakpoint",
			},

			{ "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "start/continue" },
			{ "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", desc = "step over" },
			{ "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", desc = "step into" },
			-- Arrow keys for the above keybinds instead
			{ "<Left>", "<cmd>lua require'dap'.step_out()<cr>", desc = "step out" },
			{ "<Right>", "<cmd>lua require'dap'.step_into()<cr>", desc = "step into" },
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		opts = {},
		keys = {
			{ "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", desc = "toggle dap ui" },
		},
	},

	-- INFO: -----------------------------------
	--        Specific language debuggers
	-- -----------------------------------------
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "mfussenegger/nvim-dap" },
		ft = "python", -- Load only for python files
		config = function()
			-- Note: This requires debugpy to be installed with uv: `uv add debugpy`
			require("dap-python").setup("uv")
		end,
	},

	-- TODO: No clue how to get this to work
	-- {
	-- 	"mfussenegger/nvim-jdtls", -- java lsp, debugger, etc
	-- 	dependencies = { "mfussenegger/nvim-dap" },
	-- 	ft = "java", -- Load only for Java files
	-- 	config = function()
	-- 		local bundles = {
	-- 			vim.fn.glob(nixCats("javaPaths.java_debug_dir") .. "/com.microsoft.java.debug.plugin-*.jar", true),
	-- 		}
	--
	-- 		local java_test_bundles = vim.split(vim.fn.glob(nixCats("javaPaths.java_test_dir") .. "/*.jar", true), "\n")
	-- 		local excluded = {
	-- 			"com.microsoft.java.test.runner-jar-with-dependencies.jar",
	-- 			"jacocoagent.jar",
	-- 		}
	-- 		for _, java_test_jar in ipairs(java_test_bundles) do
	-- 			local fname = vim.fn.fnamemodify(java_test_jar, ":t")
	-- 			if not vim.tbl_contains(excluded, fname) then
	-- 				table.insert(bundles, java_test_jar)
	-- 			end
	-- 		end
	--
	-- 		vim.lsp.config("jdtls", {
	-- 			init_options = {
	-- 				bundles = bundles,
	-- 			},
	-- 		})
	-- 		vim.lsp.enable("jdtls")
	-- 	end,
	-- 	keys = {
	-- 		{ "<leader>dC", "<cmd>lua require'jdtls'.test_class()<cr>", desc = "test class (java)" },
	-- 		{ "<leader>dm", "<cmd>lua require'jdtls'.test_nearest_method()<cr>", desc = "test nearest method (java)" },
	-- 	},
	-- },
}
