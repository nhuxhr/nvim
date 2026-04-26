local function get_root(buf)
  local path = vim.api.nvim_buf_get_name(buf or 0)
  if path == "" then
    path = vim.fn.getcwd()
  end
  local root = vim.fs.root(path, { ".git", ".svn", "package.json", "Makefile", ".root" })
  return root and vim.fs.normalize(root) or vim.fs.normalize(vim.fn.getcwd())
end

local function pick(name, opts)
  return function()
    opts = opts or {}
    if opts.root ~= false then
      opts.cwd = get_root()
    end
    opts.root = nil
    Snacks.picker[name](opts)
  end
end

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            ["<a-c>"] = {
              "toggle_cwd",
              mode = { "n", "i" },
            },
          },
        },
      },
      actions = {
        ---@param p snacks.Picker
        toggle_cwd = function(p)
          local root = get_root(p.input.filter.current_buf)
          local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
          local current = p:cwd()
          p:set_cwd(current == root and cwd or root)
          p:find()
        end,
      },
    },
  },
  keys = {
    -- General
    {
      "<leader>,",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    { "<leader>/", pick "grep", desc = "Grep (Root Dir)" },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    { "<leader><space>", pick "files", desc = "Find Files (Root Dir)" },
    {
      "<leader>n",
      function()
        Snacks.picker.notifications()
      end,
      desc = "Notification History",
    },
    -- Find
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>fB",
      function()
        Snacks.picker.buffers { hidden = true, nofile = true }
      end,
      desc = "Buffers (all)",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.files { cwd = vim.fn.stdpath "config" }
      end,
      desc = "Find Config File",
    },
    { "<leader>ff", pick "files", desc = "Find Files (Root Dir)" },
    { "<leader>fF", pick("files", { root = false }), desc = "Find Files (cwd)" },
    {
      "<leader>fg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Find Files (git-files)",
    },
    { "<leader>fr", pick "recent", desc = "Recent" },
    {
      "<leader>fR",
      function()
        Snacks.picker.recent { filter = { cwd = true } }
      end,
      desc = "Recent (cwd)",
    },
    {
      "<leader>fp",
      function()
        Snacks.picker.projects()
      end,
      desc = "Projects",
    },
    -- Git
    -- { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (hunks)", },
    -- { "<leader>gD", function() Snacks.picker.git_diff { base = "origin", group = true } end, desc = "Git Diff (origin)", },
    -- { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status", },
    -- { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash", },
    -- { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)", },
    -- { "<leader>gI", function() Snacks.picker.gh_issue { state = "all" } end, desc = "GitHub Issues (all)", },
    -- { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)", },
    -- { "<leader>gP", function() Snacks.picker.gh_pr { state = "all" } end, desc = "GitHub Pull Requests (all)", },
    -- Grep
    {
      "<leader>sb",
      function()
        Snacks.picker.lines()
      end,
      desc = "Buffer Lines",
    },
    {
      "<leader>sB",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "Grep Open Buffers",
    },
    { "<leader>sg", pick "grep", desc = "Grep (Root Dir)" },
    { "<leader>sG", pick("grep", { root = false }), desc = "Grep (cwd)" },
    {
      "<leader>sp",
      function()
        Snacks.picker.lazy()
      end,
      desc = "Search for Plugin Spec",
    },
    { "<leader>sw", pick "grep_word", desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
    {
      "<leader>sW",
      pick("grep_word", { root = false }),
      desc = "Visual selection or word (cwd)",
      mode = { "n", "x" },
    },
    -- Search
    {
      '<leader>s"',
      function()
        Snacks.picker.registers()
      end,
      desc = "Registers",
    },
    {
      "<leader>s/",
      function()
        Snacks.picker.search_history()
      end,
      desc = "Search History",
    },
    {
      "<leader>sa",
      function()
        Snacks.picker.autocmds()
      end,
      desc = "Autocmds",
    },
    {
      "<leader>sc",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>sC",
      function()
        Snacks.picker.commands()
      end,
      desc = "Commands",
    },
    {
      "<leader>sd",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>sD",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help Pages",
    },
    {
      "<leader>sH",
      function()
        Snacks.picker.highlights()
      end,
      desc = "Highlights",
    },
    {
      "<leader>si",
      function()
        Snacks.picker.icons()
      end,
      desc = "Icons",
    },
    {
      "<leader>sj",
      function()
        Snacks.picker.jumps()
      end,
      desc = "Jumps",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>sl",
      function()
        Snacks.picker.loclist()
      end,
      desc = "Location List",
    },
    {
      "<leader>sM",
      function()
        Snacks.picker.man()
      end,
      desc = "Man Pages",
    },
    {
      "<leader>sm",
      function()
        Snacks.picker.marks()
      end,
      desc = "Marks",
    },
    {
      "<leader>sR",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume",
    },
    {
      "<leader>sq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Quickfix List",
    },
    {
      "<leader>su",
      function()
        Snacks.picker.undo()
      end,
      desc = "Undotree",
    },
    -- UI
    {
      "<leader>uC",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Colorschemes",
    },
  },
}
