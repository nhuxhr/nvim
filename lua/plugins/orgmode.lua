return {
	"nvim-orgmode/orgmode",
	enabled = false,
	dependencies = {
		"danilshvalov/org-modern.nvim",
		"nvim-orgmode/org-bullets.nvim",
	},
	event = "VeryLazy",
	config = function()
		-- Setup orgmode
		local Menu = require("org-modern.menu")

		require("orgmode").setup({
			org_agenda_files = "~/orgfiles/**/*",
			org_default_notes_file = "~/orgfiles/refile.org",
			ui = {
				menu = {
					---@diagnostic disable-next-line: redundant-parameter
					handler = function(data)
						Menu:new():open(data)
					end,
				},
			},
		})

		require("org-bullets").setup()

		-- Keybinding to open ~/orgfiles/refile.org
		vim.keymap.set(
			"n",
			"<Leader>of",
			":e ~/orgfiles/refile.org<CR>",
			{ noremap = true, silent = true, desc = "Open refile.org" }
		)
	end,
}
