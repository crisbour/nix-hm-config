require('avante_lib').load()
require("avante").setup({
  provider = "elm_qwen",
  auto_suggestions_provider = "elm_mistralai",
  behaviour = {
    auto_suggestions = false,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    enable_token_counting = true,
    auto_add_current_file = true,
    auto_approve_tool_permissions = true,
    confirmation_ui_style = "inline_buttons",
  },
  providers = {
    elm_qwen = {
      __inherited_from = "openai",
      endpoint = "https://elm.edina.ac.uk/api/v1",
      api_key_name = "ELM_API_KEY",
      model = "Qwen/Qwen3.5-397B-A17B-FP8", -- or: mistralai/Mistral-Small-4-119B-2603
      timeout = 6000,
      extra_request_body = {
        max_tokens = 81920,
        context_window = 262144,
      }
    },
    elm_mistralai = {
      __inherited_from = "openai",
      endpoint = "https://elm.edina.ac.uk/api/v1",
      api_key_name = "ELM_API_KEY",
      model = "mistralai/Mistral-Small-4-119B-2603",
      timeout = 2500,
      extra_request_body = {
        max_tokens = 8192,
      }
    },
    ollama = {
      endpoint = 'http://127.0.0.1:11434',
      model = "qwen2.5-coder:7b",
      --model = "llama3.2",
      extra_request_body = {
        max_tokens = 8192,
      },
    },
  },
  -- FIXME: Search doesn't work due to vim.net usage, need to bump avante and neovim versions
  -- Wait for 26.11 and see if nvim 0.12.6 works
  -- web_search_engine = {
  --   provider = "tavily",
  -- },
  -- Might need to be added for evaluating work in opencode agent
  -- acp_providers = {
  --   ["opencode"] = {
  --     command = "opencode",
  --     args = { "acp" }
  --   }
  -- }
})

vim.keymap.set("n", "<A-a>", "<cmd>AvanteToggle<CR>")
