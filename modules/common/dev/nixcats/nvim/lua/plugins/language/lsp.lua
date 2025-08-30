return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.diagnostic.config({
				virtual_text = {
					current_line = true,
				},
				virtual_lines = {
					current_line = true,
				},
				signs = true,
				underline = true,
				severity_sort = true,
				update_in_insert = false,
			})

			vim.lsp.enable("lua_ls")

			vim.lsp.config("glsl_analyzer", {
				filetypes = {
					"glsl",
					"vert",
					"tesc",
					"tese",
					"frag",
					"geom",
					"comp",
					"fsh",
					"vsh",
				},
			})
			vim.lsp.enable("glsl_analyzer")

			vim.lsp.enable("zls")
			vim.lsp.enable("clangd")
			vim.lsp.enable("basedpyright")
			vim.lsp.enable("jdtls") -- java

			-- LSP keybinds
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- See `:help vim.lsp.*` for documentation on any of the below functions
					vim.keymap.set(
						"n",
						"<leader>la",
						vim.lsp.buf.code_action,
						{ buffer = ev.buf, desc = "code action" }
					)
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
					vim.keymap.set("n", "<leader>lF", function()
						local context = { only = { "source.fixAll" } }
						vim.lsp.buf.code_action({
							context = context,
							apply = true,
							filter = function(action)
								return (action.title:find("Fix all") ~= nil) or action.kind == "source.fixAll"
							end,
						})
					end, { buffer = ev.buf, desc = "fix all issues in file" })
					vim.keymap.set("n", "<leader>lf", function()
						vim.diagnostic.open_float()
					end, { buffer = ev.buf, desc = "diagnostics float" })
					vim.keymap.set(
						"n",
						"<leader>li",
						vim.lsp.buf.implementation,
						{ buffer = ev.buf, desc = "see implementation" }
					)
					vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "hover action" })
					vim.keymap.set(
						"n",
						"<leader>lt",
						vim.lsp.buf.type_definition,
						{ buffer = ev.buf, desc = "type definition" }
					)
					vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, { buffer = ev.buf, desc = "rename symbol" })
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
