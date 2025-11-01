return {
	{
		"neovim/nvim-lspconfig",
		opts = function(_, opts)
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			-- Disable the default K keymap for LSP hover
			keys[#keys + 1] = { "K", false }
		end,
	},
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
	},
	{
		"Fildo7525/pretty_hover",
		event = "LspAttach",
		opts = {
			border = "single",
			wrap = true,
			max_width = 80,
		},
    -- stylua: ignore
		keys = {
			{ "K", function() require("pretty_hover").hover() end, desc = "Pretty Hover" },
		},
	},
}
