return {
	{
		"wintermute-cell/gitignore.nvim",
		config = function()
			local gitignore = require("gitignore")
			vim.keymap.set("n", "<leader>gi", gitignore.generate)
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open LazyGit", false },
		},
	},
}
