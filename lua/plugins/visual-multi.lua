return {
  "mg979/vim-visual-multi",
  lazy = false,
  init = function()
    vim.g.VM_maps = {
      ["Find Under"] = "<C-v>",
      ["Find Subword Under"] = "<C-v>",
    }
  end,
}
