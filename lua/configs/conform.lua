local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "biome" },
    html = { "biome" },
    rust = { "rustfmt" },
    toml = { "taplo" },
    javascript = { "biome" },
    javascriptreact = { "biome" },
    typescript = { "biome" },
    typescriptreact = { "biome" },
    json = { "biome" },
    jsonc = { "biome" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
    stop_after_first = false,
  },
}

return options
