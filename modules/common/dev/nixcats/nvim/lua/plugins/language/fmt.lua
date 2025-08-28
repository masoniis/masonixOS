return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			bash = { "shfmt", "shellcheck", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			hbs = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			lua = { "stylua" },
			python = { "ruff_organize_imports", "ruff_format", "ruff_fix" },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			svelte = { "prettierd", "prettier", stop_after_first = true }, -- set up https://github.com/sveltejs/prettier-plugin-svelte for formatting to work
			markdown = { "prettierd", "prettier", stop_after_first = true },
			yaml = { "prettierd", "prettier", stop_after_first = true },
			sh = { "shfmt", "shellcheck", stop_after_first = true },
			rust = { "rustfmt" },
			toml = { "taplo" },
			java = { "google-java-format" },

			["*"] = { "codespell" }, -- Applies to all files
			["_"] = {
				"trim_whitespace", -- Applies to files with no preset formatter
			},
		},
	},
}
