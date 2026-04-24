local function get_secret(env_var, filepath)
  -- 1) Check environment variable
  local secret = vim.env[env_var]
  if secret and secret ~= "" then
    return secret
  end

  -- 2) Fallback to file
  local expanded_path = vim.fn.expand(filepath or "")
  local f = io.open(expanded_path, "r")
  if not f then
    return nil
  end

  local s = f:read "*a"
  f:close()
  if not s then
    return nil
  end

  -- Trim trailing whitespace/newlines
  s = s:gsub("%s+$", "")
  -- Return nil if file content is empty
  if s == "" then
    return nil
  end

  -- Return the secret
  return s
end

return {
  {
    "olimorris/codecompanion.nvim",
    version = "^20.0.0",
    lazy = false,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
      "nvim-telescope/telescope.nvim",
      {
        "stevearc/dressing.nvim",
        opts = {},
      },
    },
    config = function()
      require("codecompanion").setup {
        strategies = {
          chat = {
            adapter = {
              name = "ollama",
              model = "devstral-small-2",
            },
            roles = {
              llm = "CodeCompanion", -- The markdown header content for the LLM's responses
              user = "Astron", -- The markdown header for your questions
            },
          },
          inline = {
            adapter = {
              name = "ollama",
              model = "devstral-small-2",
            },
          },
          agent = {
            adapter = {
              name = "ollama",
              model = "devstral-small-2",
            },
          },
        },
        adapters = {
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              url = "https://inference.do-ai.run/v1/chat/completions",
              env = {
                api_key = get_secret("OPENAI_API_KEY", "~/.secrets/openai.key"),
              },
              schema = {
                model = {
                  default = "openai-o1",
                },
              },
            })
          end,
          ollama = function()
            return require("codecompanion.adapters").extend("ollama", {
              env = {
                url = "http://localhost:11434",
              },
              parameters = {
                sync = true,
              },
            })
          end,
        },
        opts = {
          log_level = "DEBUG",
        },
      }

      vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
      vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
      vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

      -- Expand 'cc' into 'CodeCompanion' in the command line
      vim.cmd [[cab cc CodeCompanion]]
    end,
  },
}
