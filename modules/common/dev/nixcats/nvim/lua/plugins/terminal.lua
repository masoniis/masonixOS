return {
	{
		"nvzone/floaterm",
		dependencies = "nvzone/volt",
		opts = {
			size = { h = 85, w = 90 },
			terminals = {
				{ name = "Term 0" },
				{ name = "G Term", cmd = "onefetch" },
				{ name = "Terminull", cmd = "neofetch" },
			},
			mappings = {
				sidebar = function(buf)
					vim.keymap.set(
						{ "n", "t" },
						nixCats("binds.close_window"),
						"<cmd>FloatermToggle<CR>",
						{ buffer = buf }
					)
					vim.keymap.set({ "n", "t" }, nixCats("binds.terminals.floaterm_new"), function()
						require("floaterm.api").new_term()
					end, { buffer = buf })
					vim.keymap.set({ "n", "t" }, nixCats("binds.splits.move_left"), function()
						require("floaterm.api").switch_wins()
					end, { buffer = buf })
					vim.keymap.set({ "n", "t" }, nixCats("binds.splits.move_right"), function()
						require("floaterm.api").switch_wins()
					end, { buffer = buf })
				end,
				term = function(buf)
					vim.keymap.set(
						{ "n", "t" },
						nixCats("binds.close_window"),
						"<cmd>FloatermToggle<CR>",
						{ buffer = buf }
					)
					vim.keymap.set({ "n", "t" }, nixCats("binds.terminals.floaterm_new"), function()
						require("floaterm.api").new_term()
					end, { buffer = buf })
				end,
			},
		},
		keys = {
			{
				nixCats("binds.terminals.floaterm_toggle"),
				"<cmd>FloatermToggle<CR>",
				desc = "toggle floaterm",
			},
		},
		cmd = "FloatermToggle",
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			local Terminal = require("toggleterm.terminal").Terminal

			--INFO: Terminals
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
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"n",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"t",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
					vim.api.nvim_buf_set_keymap(term.bufnr, "n", "Q", "<cmd>q!<CR>", { noremap = true, silent = true })
				end,
				on_exit = function(term, code)
					if code == 0 then
						vim.cmd("q!") -- Close the terminal if it exits successfully
					else
						vim.api.nvim_buf_set_keymap(
							term.bufnr,
							"n",
							"q",
							"<cmd>q!<CR>",
							{ noremap = true, silent = true }
						)
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
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"n",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"t",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
					-- Kill the terminal with Q
					vim.api.nvim_buf_set_keymap(term.bufnr, "n", "Q", "<cmd>q!<CR>", { noremap = true, silent = true })
				end,
				on_exit = function(term, code)
					if vim.api.nvim_get_current_buf() ~= term.bufnr then -- If buffer is not being displayed
						vim.notify("Home Manager switch complete with exit code: " .. code)
						-- TODO: dont close if it's an error code, tho home manager
						pcall(vim.api.nvim_buf_delete, term.bufnr, { force = true })
					else
						vim.api.nvim_buf_set_keymap(
							term.bufnr,
							"n",
							"q",
							"<cmd>q!<CR>",
							{ noremap = true, silent = true }
						)
					end
				end,
			})

			local spotify = Terminal:new({
				cmd = "spotify_player",
				dir = "git_dir",
				direction = "float",
				on_open = function(term)
					vim.cmd("startinsert!")
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"n",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"t",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
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
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"n",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"t",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
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
						vim.api.nvim_buf_set_keymap(
							term.bufnr,
							"n",
							"q",
							"<cmd>q!<CR>",
							{ noremap = true, silent = true }
						)
						vim.api.nvim_buf_set_keymap(
							term.bufnr,
							"t",
							"q",
							"<cmd>q!<CR>",
							{ noremap = true, silent = true }
						)
					end
				end,
			})

			--  INFO: Global functions
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
				nixCats("binds.terminals.ollama"),
				function()
					_Ollama_Toggle()
				end,
				desc = "ollama serve term",
			},
			{
				nixCats("binds.terminals.home_manager"),
				function()
					_HomeManagerSwitch()
				end,
				desc = "hm switch term",
			},
			{
				nixCats("binds.terminals.spotify"),
				function()
					_Spotify_Toggle()
				end,
				desc = "spotify term",
			},
			{
				nixCats("binds.terminals.flutter"),
				function()
					_FlutterRun()
				end,
				desc = "flutter run term",
			},
		},
	},
}
