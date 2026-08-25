require("nvchad.configs.lspconfig").defaults()

vim.lsp.config("cssls", {
  settings = {
    css = {
      validate = true,
      lint = {
        unknownAtRules = "ignore", -- Tells cssls to ignore @variant and @theme
      },
    },
  },
})

local servers = { "html", "cssls", "rust_analyzer", "taplo", "ts_ls", "biome", "tailwindcss" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
