-- Tools is for any language specific "tools" that don't get covered by the braod
-- language server, formatter, etc.
return {
	-- Adds basic uml syntax highlighting and a convenient viewer
	{
		"javiorfo/nvim-soil",
		dependencies = { "javiorfo/nvim-nyctophilia" },
		lazy = true,
		ft = "plantuml",
		opts = {
			-- This option closes the image viewer and reopen the image generated
			-- When true this offers some kind of online updating (like plantuml web server)
			actions = {
				redraw = false,
			},
			image = {
				darkmode = true,
				format = "png",
				-- shell command (works on mac only b/c 'open') to open image
				execute_to_open = function(img)
					return "open " .. img
				end,
			},
		},
	},
}
