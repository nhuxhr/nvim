vim.lsp.config("biome", {
  root_dir = vim.fs.root(0, { "biome.json", "biome.jsonc" }),
  single_file_support = false, -- only attach when biome.json is present
})
