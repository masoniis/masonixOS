return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		-- WARNING: warning warnging WARNING
		-- FIX: fix fix fix fix fix  FIX
		-- TODO: do todo something   TODO
		-- HACK: hack something hack HACK
		-- INFO: SOME INFORMATION    INFO
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
}
