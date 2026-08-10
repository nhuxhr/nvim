return {
  "mg979/vim-visual-multi",
  lazy = false,
  init = function()
    vim.g.VM_maps = {
      ["Find Under"] = "<C-j>",
      ["Find Subword Under"] = "<C-j>",
    }
  end,
}
