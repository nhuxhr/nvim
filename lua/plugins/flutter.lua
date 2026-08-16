return {
  "nvim-flutter/flutter-tools.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "stevearc/dressing.nvim", -- optional for vim.ui.select
  },
  keys = {
    { "<leader>dfs", "<cmd>FlutterRun<cr>", desc = "Flutter Run" },
    { "<leader>dfr", "<cmd>FlutterReload<cr>", desc = "Flutter Hot Reload" },
    { "<leader>dfR", "<cmd>FlutterRestart<cr>", desc = "Flutter Hot Restart" },
    { "<leader>dfl", "<cmd>FlutterLogToggle<cr>", desc = "Toggle Flutter Log" },
    { "<leader>dfq", "<cmd>FlutterQuit<cr>", desc = "Quit Flutter App" },
  },
  config = true,
}
