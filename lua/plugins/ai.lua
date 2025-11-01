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

	local s = f:read("*a")
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

vim.env.AVANTE_OPENAI_API_KEY = get_secret("OPENAI_API_KEY", "~/.secrets/openai.key")

return {
	{
		"yetone/avante.nvim",
		enabled = false,
		event = "VeryLazy",
		lazy = false, -- Load early for suggestions
		version = false, -- Use latest
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		opts = {
			provider = "openai", -- Default to your endpoint
			auto_suggestions = true, -- Enable ghost text (experimental)
			auto_suggestions_provider = "openai:5:nano", -- Or "ollama" for local
			behaviour = {
				auto_suggestions = true,
				debounce = 600, -- ms delay for triggers
				throttle = 600,
			},
			mappings = {
				suggestion = {
					accept = "<M-l>", -- Alt+L to accept inline
					next = "<M-]>", -- Next suggestion
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			providers = {
				openai = {
					endpoint = "https://inference.do-ai.run/v1",
					model = "openai-o1",
					timeout = 30000,
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 20480,
					},
				},
				["openai:5:nano"] = {
					__inherited_from = "openai",
					endpoint = "https://inference.do-ai.run/v1",
					model = "openai-gpt-5-nano",
				},
				ollama = { -- Switch via :AvanteSetProvider ollama
					endpoint = "http://localhost:11434",
					model = "deepseek-coder:6.7b", -- Pull via `ollama pull deepseek-coder:6.7b`
					is_env_set = function()
						return true
					end,
				},
			},
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"nvim-mini/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"stevearc/dressing.nvim", -- for input provider dressing
			"folke/snacks.nvim", -- for input provider snacks
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
	{
		"olimorris/codecompanion.nvim",
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
			require("codecompanion").setup({
				strategies = {
					chat = {
						adapter = {
							name = "openai",
							model = "llama3.3-70b-instruct",
						},
						roles = {
							llm = "CodeCompanion", -- The markdown header content for the LLM's responses
							user = "Astron", -- The markdown header for your questions
						},
					},
					inline = {
						adapter = {
							name = "openai",
							model = "llama3.3-70b-instruct",
						},
					},
					agent = {
						adapter = {
							name = "openai",
							model = "llama3.3-70b-instruct",
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
				},
				opts = {
					log_level = "DEBUG",
				},
			})

			vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
			vim.keymap.set(
				{ "n", "v" },
				"<LocalLeader>a",
				"<cmd>CodeCompanionChat Toggle<cr>",
				{ noremap = true, silent = true }
			)
			vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

			-- Expand 'cc' into 'CodeCompanion' in the command line
			vim.cmd([[cab cc CodeCompanion]])
		end,
	},
}
