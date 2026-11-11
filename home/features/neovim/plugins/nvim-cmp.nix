{ pkgs, ... }:
with pkgs;
let
  luaPlugin = pkg: {
    type = "lua";
    plugin = pkg;
  };
in {
  home.packages = [
    nodejs # copilot-lua needes it
  ];
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (luaPlugin cmp-async-path)
      (luaPlugin cmp-fuzzy-buffer)
      (luaPlugin cmp-nvim-lsp)
      (luaPlugin cmp-nvim-lsp-signature-help)
      (luaPlugin lspkind-nvim)
      (luaPlugin luasnip)
      {
        type = "lua";
        plugin = cmp-ai;
        config = ''
          require('cmp_ai').setup()
        '';
      }
      {
        plugin = minuet-ai-nvim;
        config = ''
          require('minuet').setup {
            provider = 'openai_compatible',
            request_timeout = 2.5,
            -- throttle = 1500, -- Increase to reduce costs and avoid rate limits
            -- debounce = 600, -- Increase to reduce costs and avoid rate limits
            provider_options = {
                openai_compatible = {
                    api_key = 'ELM_API_KEY',
                    -- API docs: https://elm.edina.ac.uk/elm/help/proxy-api and https://elm.edina.ac.uk/swagger-ui/index.html
                    end_point = 'https://elm.edina.ac.uk/api/v1/chat/completions',
                    model = 'mistralai/Mistral-Small-4-119B-2603',
                    name = 'elm',
                    optional = {
                        max_tokens = 1024,
                        top_p = 0.9,
                        -- disable thinking to avoid first token latency
                        thinking = { type = 'disabled' },
                    },
                },
            },
        }
        '';
      }
      {
        type = "lua";
        plugin = pkgs.unstable.vimPlugins.copilot-cmp;
        config = ''
        local cmp_ai = require('cmp_ai.config')

        cmp_ai:setup({
          max_lines = 100,
          provider = 'Ollama',
          provider_options = {
            model = 'qwen2.5-coder:7b',
            auto_unload = false, -- Set to true to automatically unload the model when
                                 -- exiting nvim.
          },
          notify = true,
          notify_callback = function(msg)
            vim.notify(msg)
          end,
          run_on_every_keystroke = true,
          ignored_file_types = {
            -- default is not to ignore
            -- uncomment to ignore in lua:
            -- lua = true
          },
        })
        '';
      }
      # FIXME: Spell checking is disabled because it's not code aware
      #{
      #  type = "lua";
      #  plugin = cmp-spell;
      #  config = ''
      #    vim.opt.spell = true
      #    vim.opt.spelllang = { 'en_us' }
      #  '';
      #}
      {
        type = "lua";
        plugin = nvim-cmp;
        config = builtins.readFile ./config/nvim-cmp.lua;
      }
    ];
  };
}
