{pkgs, config, ...}:
{
  # FIXME: variables not set
  #home.sessionVariables = {
  #  ELM_API_KEY_PATH    = config.sops.secrets.elm_api_key.path;
  #  TAVILY_API_KEY_PATH = config.sops.secrets.tavily_api_key.path;
  #  MORPH_API_KEY_PATH  = config.sops.secrets.morph_api_key.path;
  #};

  home.packages = [
    pkgs.unstable.copilot-language-server
  ];

  programs.neovim.plugins = with pkgs.vimPlugins; [
    # Markdown preview
    {
      plugin = render-markdown-nvim;
      config = ''
        require("render-markdown").setup({
          file_types = { "Avante" },
        });
      '';
    }

    # Helpers
    ## Avante with ELM
    {
      # Use overlay from ../../overlays/avante.nix for latest version (fixes Neovim 0.12+ compatibility)
      plugin = pkgs.unstable.vimPlugins.avante-nvim;
      config = builtins.readFile ../neovim/plugins/config/avante-nvim.lua;
    }
    # Copilot setup as suggested by: https://tamerlan.dev/setting-up-copilot-in-neovim-with-sane-settings/
    {
      plugin = pkgs.unstable.vimPlugins.copilot-lua;
      config = builtins.readFile ../neovim/plugins/config/copilot-lua.lua;
    }
    ## Completion
    {
      type = "lua";
      plugin = pkgs.unstable.vimPlugins.copilot-cmp;
      config = ''
        require("copilot_cmp").setup()
      '';
    }
    #{
    #  plugin = minuet-ai-nvim;
    #  config = ''
    #    require('minuet').setup {
    #      provider = 'openai_compatible',
    #      request_timeout = 2.5,
    #      -- throttle = 1500, -- Increase to reduce costs and avoid rate limits
    #      -- debounce = 600, -- Increase to reduce costs and avoid rate limits
    #      provider_options = {
    #          openai_compatible = {
    #              api_key = 'ELM_API_KEY',
    #              -- API docs: https://elm.edina.ac.uk/elm/help/proxy-api and https://elm.edina.ac.uk/swagger-ui/index.html
    #              end_point = 'https://elm.edina.ac.uk/api/v1/chat/completions',
    #              model = 'mistralai/Mistral-Small-4-119B-2603',
    #              name = 'elm',
    #              optional = {
    #                  max_tokens = 1024,
    #                  top_p = 0.9,
    #                  -- disable thinking to avoid first token latency
    #                  thinking = { type = 'disabled' },
    #              },
    #          },
    #      },
    #  }
    #  '';
    #}
  ];


}


