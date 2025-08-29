return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local Terminal = require("toggleterm.terminal").Terminal

		--INFO: Terminals
		local togglefloat = Terminal:new({
			direction = "float",
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "Q", "<cmd>q!<CR>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(
					term.bufnr,
					"t",
					"<esc><esc>",
					"<C-\\><C-n>",
					{ noremap = true, silent = true }
				)
			end,
		})

		local ollama = Terminal:new({
			cmd = "ollama serve",
			dir = "git_dir",
			direction = "float",
			start_in_insert = false,
			close_on_exit = false,
			on_create = function()
				vim.cmd("stopinsert")
			end,
			on_open = function(term)
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "q", "<cmd>close<CR>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "Q", "<cmd>q!<CR>", { noremap = true, silent = true })
			end,
			on_exit = function(term, code)
				if code == 0 then
					vim.cmd("q!") -- Close the terminal if it exits successfully
				else
					vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>q!<CR>", { noremap = true, silent = true })
				end
			end,
		})

		local hm_switch = Terminal:new({
			-- TODO: Pass in path using require("nixcats.PATH") from nixcats default.nix
			cmd = "home-manager switch --flake /Users/mason/.config/masonixOS",
			dir = "git_dir",
			direction = "float",
			start_in_insert = false,
			close_on_exit = false, -- Keep term open in case of error
			on_create = function()
				vim.cmd("stopinsert")
			end,
			on_open = function(term)
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "q", "<cmd>close<CR>", { noremap = true, silent = true })
				-- Kill the terminal with Q
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "Q", "<cmd>q!<CR>", { noremap = true, silent = true })
			end,
			on_exit = function(term, code)
				if vim.api.nvim_get_current_buf() ~= term.bufnr then -- If buffer is not being displayed
					vim.notify("Home Manager switch complete with exit code: " .. code)
					-- TODO: dont close if it's an error code, tho home manager
					pcall(vim.api.nvim_buf_delete, term.bufnr, { force = true })
				else
					vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>q!<CR>", { noremap = true, silent = true })
				end
			end,
		})

		local spotify = Terminal:new({
			cmd = "spotify_player",
			dir = "git_dir",
			direction = "float",
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "q", "<cmd>close<CR>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "Q", "<cmd>q!<CR>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "Q", "<cmd>q!<CR>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-d>", "<C-c>", { silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<esc>", { noremap = true, silent = true })

				-- Disable <C-h> and <C-l> in both normal and terminal modes so we can use them in the term
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<C-h>", "<C-h>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<C-l>", "<C-l>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-h>", "<C-h>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-l>", "<C-l>", { noremap = true, silent = true })
			end,
			on_exit = function(term, code)
				-- Remove the <C-h> and <C-l> mappings so that the global mappings are effective again.
				pcall(vim.api.nvim_buf_del_keymap, term.bufnr, "n", "<C-h>")
				pcall(vim.api.nvim_buf_del_keymap, term.bufnr, "n", "<C-l>")
				pcall(vim.api.nvim_buf_del_keymap, term.bufnr, "t", "<C-h>")
				pcall(vim.api.nvim_buf_del_keymap, term.bufnr, "t", "<C-l>")
			end,
		})

		local flutter_run = Terminal:new({
			cmd = "flutter run",
			dir = "git_dir",
			direction = "float",
			close_on_exit = false, -- Keep term open in case of error
			on_open = function(term)
				vim.cmd("startinsert!")
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "q", "<cmd>close<CR>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "Q", "<cmd>q!<CR>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "Q", "<cmd>q!<CR>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-d>", "<C-c>", { silent = true })
				vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<esc>", { noremap = true, silent = true })
			end,
			on_exit = function(term, code)
				if vim.api.nvim_get_current_buf() ~= term.bufnr then -- If buffer is not being displayed
					vim.notify("Flutter exited with code: " .. code)
					pcall(vim.api.nvim_buf_delete, term.bufnr, { force = true })
				else
					vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>q!<CR>", { noremap = true, silent = true })
					vim.api.nvim_buf_set_keymap(term.bufnr, "t", "q", "<cmd>q!<CR>", { noremap = true, silent = true })
				end
			end,
		})

		--  INFO: Global functions
		function _ToggleTerm()
			togglefloat:toggle()
		end

		function _Ollama_Toggle()
			ollama:toggle()
		end

		function _HomeManagerSwitch()
			hm_switch:toggle()
		end

		function _Spotify_Toggle()
			spotify:toggle()
		end

		function _FlutterRun()
			flutter_run:toggle()
		end
	end,
	keys = {
		-- INFO: Toggle keymaps
		{
			"<leader>tt",
			function()
				_ToggleTerm()
			end,
			desc = "floating term",
		},
		{
			"<leader>to",
			function()
				_Ollama_Toggle()
			end,
			desc = "ollama serve term",
		},
		{
			"<leader>th",
			function()
				_HomeManagerSwitch()
			end,
			desc = "hm switch term",
		},
		{
			"<leader>ts",
			function()
				_Spotify_Toggle()
			end,
			desc = "spotify term",
		},
		{
			"<leader>tf",
			function()
				_FlutterRun()
			end,
			desc = "flutter run term",
		},
	},
}
