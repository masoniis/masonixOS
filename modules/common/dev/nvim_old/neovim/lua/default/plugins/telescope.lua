return {
	"nvim-telescope/telescope.nvim", -- fuzzy finder
	dependencies = { "BurntSushi/ripgrep", "nvim-lua/plenary.nvim" },
	config = function()
		local status_ok, telescope = pcall(require, "telescope")
		if not status_ok then
			vim.notify("Telescope failed to initialize.")
			return
		end

		-- Extension for project.nvim
		telescope.load_extension("projects")

		telescope.setup({})
	end,
	cmd = "Telescope", -- lazy load on any telescope cmd
	keys = {
		{
			"<leader>ff",
			"<cmd>Telescope find_files<cr>",
			desc = "search cwd files",
		},
		{ "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "lsp diagnostics" },
		{
			"<leader>fg",
			"<cmd>Telescope live_grep<cr>",
			desc = "search live grep",
		},
		{
			"<leader>fr",
			"<cmd>Telescope oldfiles<cr>",
			desc = "search recent files",
		},
		{ "<leader>p", "<cmd>Telescope commands<cr>", desc = "search commands" },
		{ "<C-p>", ":lua require'telescope.builtin'.git_files{use_git_root=false}<CR>", desc = "search git repo" },
		{
			"<C-f>",
			"<cmd>Telescope current_buffer_fuzzy_find <CR>",
			"current buffer fuzzy find",
		},
	},
}
