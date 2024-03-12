-- Controls the language servers for environments, and assists completion (cmp)

return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf",                                config = true },
			{ "folke/neodev.nvim",  opts = { experimental = { pathStrict = true } } },
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local lspconfig = require('lspconfig')

			--WARNING: lspconfig.rust_analyzer.setup {} THIS IS CONFIGURED THROUGH rust.lua
			lspconfig.lua_ls.setup {}
			-- lspconfig.nil_ls.setup {}
			lspconfig.nixd.setup {}
			lspconfig.tsserver.setup {}
			lspconfig.tailwindcss.setup {}
			lspconfig.html.setup {}
			lspconfig.jsonls.setup {}
			lspconfig.svelte.setup {}

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				severity_sort = true,
				update_in_insert = false,
			})

			-- Following lines are from : https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#show-line-diagnostics-automatically-in-hover-window
			-- You will likely want to reduce updatetime which affects CursorHold
			-- note: this setting is global and should be set only once
			-- Hover
			-- vim.o.updatetime = 250
			-- vim.cmd([[autocmd! CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]])

			-- LSP keybinds
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set(
						"n",
						"<leader>lD",
						vim.lsp.buf.declaration,
						{ buffer = ev.buf, desc = "see declaration" }
					)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc = "hover action" })
					vim.keymap.set("n", "<leader>lK", vim.lsp.buf.hover, { buffer = ev.buf, desc = "hover action" })
					vim.keymap.set(
						"n",
						"<leader>ld",
						vim.lsp.buf.definition,
						{ buffer = ev.buf, desc = "see definition" }
					)
					vim.keymap.set(
						"n",
						"<leader>li",
						vim.lsp.buf.implementation,
						{ buffer = ev.buf, desc = "see implementation" }
					)

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

			-- vim.api.nvim_create_autocmd("CursorHold", {
			-- 	buffer = bufnr,
			-- 	callback = function()
			-- 		local opts = {
			-- 			focusable = false,
			-- 			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			-- 			border = "rounded",
			-- 			source = "always",
			-- 			prefix = " ",
			-- 			scope = "cursor",
			-- 		}
			-- 		vim.diagnostic.open_float(nil, opts)
			-- 	end,
			-- })
		end,
	},
	{
		"j-hui/fidget.nvim", -- Fidget spinner showing lsp processes
		tag = "legacy",    -- To avoid breaking changes
		config = function()
			require("fidget").setup({})
		end,
	},
}
