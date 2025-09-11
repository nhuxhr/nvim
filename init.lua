require("config.lazy")

vim.cmd("colorscheme kanagawa")

local lspconfig = require("lspconfig")
lspconfig.rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {
			procMacro = {
				enable = true,
			},
		},
	},
})
