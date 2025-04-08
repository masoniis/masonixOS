require("inc_rename").setup()

-- Fix issues with nvim assuming frag, vert, etc files are .conf files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.vsh", "*.fsh", "*.frag", "*.vert" },
	command = "set filetype=glsl",
	group = vim.api.nvim_create_augroup("vsh_filetype", { clear = true }),
})

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = false,
	severity_sort = true,
	update_in_insert = false,
})

-- vim.o.updatetime = 250
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false })
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local bufnr = args.buf
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client.supports_method("textDocument/completion") then
			vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
		end
		if client.supports_method("textDocument/definition") then
			vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
		end
		--INFO: LSP keybinds defined here
		vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "see declaration" })
		vim.keymap.set("n", "<leader>lK", vim.lsp.buf.hover, { buffer = bufnr, desc = "hover action" })
		vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { buffer = bufnr, desc = "see definition" })
		vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, { buffer = bufnr, desc = "see implementation" })
		vim.keymap.set("n", "<leader>lt", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "type definition" })
		vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, { buffer = bufnr, desc = "rename symbol" })
		vim.keymap.set("n", "<leader>lF", function()
			local context = { only = { "source.fixAll" } }
			vim.lsp.buf.code_action({
				context = context,
				apply = true,
				filter = function(action)
					return action.title:find("Fix all") or action.kind == "source.fixAll"
				end,
			})
		end, { buffer = bufnr, desc = "fix all issues in file" })
		vim.keymap.set(
			"n",
			"<leader>la",
			require("actions-preview").code_actions,
			{ buffer = bufnr, desc = "code action menu" }
		)

		vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, { buffer = bufnr, desc = "references" })
		vim.keymap.set("n", "<leader>lR", function()
			return ":IncRename " .. vim.fn.expand("<cword>")
		end, { expr = true, desc = "rename" })
		vim.keymap.set("n", "<leader>lf", function()
			vim.diagnostic.open_float()
		end, { buffer = bufnr, desc = "diagnostics float" })
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "hover action" })
	end,
})
