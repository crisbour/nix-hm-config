require('avante_lib').load()
require("avante").setup({
  provider = "copilot",
  auto_suggestions_provider = "copilot",
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
    elm = {
      __inherited_from = "openai",
      endpoint = "https://api.anthropic.com",
      api_key_name = "ELM_API_KEY",
      model = "Qwen/Qwen3.5-397B-A17B-FP8", -- or: mistralai/Mistral-Small-4-119B-2603
      timeout = 6000,
      extra_request_body = {
        max_tokens = 262144,
      }
    }
  }
})
