return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.diagnostic.config({
				virtual_text = false,
				virtual_lines = {
					current_line = true,
				},
				signs = true,
				underline = true,
				severity_sort = true,
				update_in_insert = false,
			})

			-- INFO: ------------------------------
			--        Default config servers
			-- ------------------------------------
			vim.lsp.enable("basedpyright")
			vim.lsp.enable("tailwindcss")
			vim.lsp.enable("clangd")
			-- vim.lsp.enable("jdtls") -- java is handeld in dap.lua
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("selene3p_ls") -- lua linter
			vim.lsp.enable("ts_ls")
			vim.lsp.enable("nixd")
			vim.lsp.enable("zls") -- zig

			-- INFO: -------------------------------
			--         Tweaked config servers
			-- -------------------------------------

			vim.lsp.config("svelte", {
				cmd = {
					"bunx",
					"svelte-language-server",
					"--stdio",
				},
				settings = {},
			})
			vim.lsp.enable("svelte")

			vim.lsp.config("rust_analyzer", {
				settings = {
					["rust-analyzer"] = {
						cargo = {
							build_scripts = {
								enable = true,
							},
						},
						procMacro = {
							enable = true,
						},
					},
				},
			})
			vim.lsp.enable("rust_analyzer")

			vim.lsp.config("wgsl_analyzer", {
				filetypes = {
					"wgsl",
					-- "wesl" wesl support is still WIP
				},
			})
			vim.lsp.enable("wgsl_analyzer") -- webgpu shader lang

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

			-- INFO: ----------------
			--         Keymaps
			-- ----------------------
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- See `:help vim.lsp.*` for documentation on any of the below functions
					vim.keymap.set(
						"n",
						nixCats("binds.lsp.code_action"),
						vim.lsp.buf.code_action,
						{ buffer = ev.buf, desc = "code action" }
					)
					vim.keymap.set(
						"n",
						nixCats("binds.lsp.declaration"),
						vim.lsp.buf.declaration,
						{ buffer = ev.buf, desc = "see declaration" }
					)
					vim.keymap.set(
						"n",
						nixCats("binds.lsp.definition"),
						vim.lsp.buf.definition,
						{ buffer = ev.buf, desc = "see definition" }
					)
					vim.keymap.set("n", nixCats("binds.lsp.fix_all"), function()
						local context = { only = { "source.fixAll" } }
						vim.lsp.buf.code_action({
							context = context,
							apply = true,
							filter = function(action)
								return (action.title:find("Fix all") ~= nil) or action.kind == "source.fixAll"
							end,
						})
					end, { buffer = ev.buf, desc = "fix all issues in file" })
					vim.keymap.set("n", nixCats("binds.lsp.diagnostics_float"), function()
						vim.diagnostic.open_float()
					end, { buffer = ev.buf, desc = "diagnostics float" })
					vim.keymap.set(
						"n",
						nixCats("binds.lsp.implementation"),
						vim.lsp.buf.implementation,
						{ buffer = ev.buf, desc = "see implementation" }
					)
					vim.keymap.set(
						"n",
						nixCats("binds.lsp.hover"),
						vim.lsp.buf.hover,
						{ buffer = ev.buf, desc = "hover action" }
					)
					vim.keymap.set(
						"n",
						nixCats("binds.lsp.type_definition"),
						vim.lsp.buf.type_definition,
						{ buffer = ev.buf, desc = "type definition" }
					)
					vim.keymap.set(
						"n",
						nixCats("binds.lsp.rename_symbol"),
						vim.lsp.buf.rename,
						{ buffer = ev.buf, desc = "rename symbol" }
					)
					vim.keymap.set(
						"n",
						nixCats("binds.lsp.references"),
						vim.lsp.buf.references,
						{ buffer = ev.buf, desc = "references" }
					)
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
		"folke/lazydev.nvim", -- better lua library support for language server
		ft = "lua",
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
