return {
	{
		"neovim/nvim-lspconfig",
		lazy = false, -- Since this is just a data repo, load at startup
		priority = 99,
		config = function()
			vim.diagnostic.config({
				virtual_text = false,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = false,
			})

			vim.lsp.enable("lua_ls")

			-- JDTLS stuff
			local bundles = {
				vim.fn.glob(nixCats("javaPaths.java_debug_dir") .. "/com.microsoft.java.debug.plugin-*.jar", true),
			}

			local java_test_bundles = vim.split(vim.fn.glob(nixCats("javaPaths.java_test_dir") .. "/*.jar", true), "\n")
			local excluded = {
				"com.microsoft.java.test.runner-jar-with-dependencies.jar",
				"jacocoagent.jar",
			}
			for _, java_test_jar in ipairs(java_test_bundles) do
				local fname = vim.fn.fnamemodify(java_test_jar, ":t")
				if not vim.tbl_contains(excluded, fname) then
					table.insert(bundles, java_test_jar)
				end
			end

			vim.lsp.config("jdtls", {
				init_options = {
					bundles = bundles,
				},
			})
			vim.lsp.enable("jdtls")

			-- LSP keybinds
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- See `:help vim.lsp.*` for documentation on any of the below functions
					vim.keymap.set(
						"n",
						"<leader>lD",
						vim.lsp.buf.declaration,
						{ buffer = ev.buf, desc = "see declaration" }
					)
					vim.keymap.set(
						"n",
						"<leader>ld",
						vim.lsp.buf.definition,
						{ buffer = ev.buf, desc = "see definition" }
					)
					vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "hover action" })
					vim.keymap.set(
						"n",
						"<leader>li",
						vim.lsp.buf.implementation,
						{ buffer = ev.buf, desc = "see implementation" }
					)

					-- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts) -- collides with window changing
					-- vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
					-- vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
					-- vim.keymap.set("n", "<space>wl", function()
					-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					-- end, opts)
					vim.keymap.set(
						"n",
						"<leader>lt",
						vim.lsp.buf.type_definition,
						{ buffer = ev.buf, desc = "type definition" }
					)
					vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, { buffer = ev.buf, desc = "rename symbol" })
					vim.keymap.set(
						"n",
						"<leader>la",
						vim.lsp.buf.code_action,
						{ buffer = ev.buf, desc = "code action" }
					)
					vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, { buffer = ev.buf, desc = "references" })
				end,
			})
		end,
	},
	{
		"j-hui/fidget.nvim", -- Fidget spinner showing lsp processes
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "neovim/nvim-lspconfig" },
		options = {},
	},
	{
		"folke/lazydev.nvim", -- better lua nvim conf support
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "LazyVim", words = { "LazyVim" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
				{ "nvim-dap-ui" },
			},
		},
	},
}
