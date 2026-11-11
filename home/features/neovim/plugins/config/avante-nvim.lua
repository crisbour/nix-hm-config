require('avante_lib').load()
require("avante").setup({
  provider = "elm_qwen",
  auto_suggestions_provider = "elm_mistralai",
  behaviour = {
    auto_suggestions = true,
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
      timeout = 6000,
      extra_request_body = {
        max_tokens = 81920,
        context_window = 262144,
      }
    },
    -- FIXME: Investigate integration with ollama
    ollama = {
      endpoint = "http://127.0.0.1:11434", -- Note that there is no /v1 at the end.
      model = "qwq:32b",
    },
  }
})

vim.keymap.set("n", "<A-a>", "<cmd>AvanteToggle<CR>")

vim.api.nvim_create_autocmd("FileType", {
  pattern = "Avante",
  callback = function()
    -- Force treesitter to treat this buffer as markdown for injection purposes
    vim.treesitter.language.add("markdown")
  end,
})
