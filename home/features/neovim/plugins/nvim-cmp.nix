{ pkgs, ... }:
with pkgs;
let
  luaPlugin = pkg: {
    type = "lua";
    plugin = pkg;
  };
  cmp_zotcite = pkgs.vimUtils.buildVimPlugin rec {
    version = "main";
    #versionSuffix = "pre${toString src.revCount or 0}.${src.shortRev or "0000000"}";
    pname = "cmp_zotcite-${version}";
    src = pkgs.fetchFromGitHub {
      owner = "jalvesaq";
      repo = "cmp-zotcite";
      rev = "1fde8141b77fdef634739a519fa3a56d7ec9292d";
      sha256 = "sha256-8gyYlUq4Z+1w+IbmYF+43JsMsHjGo2dXqlm6zeV2YNE=";
    };
    doCheck = false;
    meta.homepage = "https://github.com/jalvesaq/cmp-zotcite";
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
        plugin = cmp_zotcite;
        config = ''
          require'cmp_zotcite'.setup({
            filetypes = {"pandoc", "markdown", "rmd", "quarto"}
          })
        '';
      }
      # Copilot setup as suggested by: https://tamerlan.dev/setting-up-copilot-in-neovim-with-sane-settings/
      {
        # TODO: Customize experience with Copilot
        type = "lua";
        plugin = copilot-lua;
        config = ''
        require('copilot').setup({
          -- Disable suggestions and panel as they can interfere with cmp appearing in copilot-cmp
          suggestion = { enabled = false },
          panel = { enabled = false },
          -- TODO: Customize copilot response https://github.com/zbirenbaum/copilot.lua
        })
        '';
      }
      {
        type = "lua";
        plugin = copilot-cmp;
        config = ''
          require('copilot_cmp').setup()
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
        config = ''
          local cmp = require("cmp")
          local luasnip = require("luasnip")

          local has_words_before = function()
            if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
          end

          cmp.setup({
            formatting = {
              format = require("lspkind").cmp_format({
                mode = 'symbol', -- show only symbol annotations
                maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                symbol_map = { Copilot = "" },
                ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                preset = "codicons", -- codicons preset
              })
            },
            preselect = cmp.PreselectMode.None,
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end,
            },
            sources = {
              { name = "nvim_lsp", priority = 100 },
              { name = "nvim_lsp_signature_help", priority = 90 },
              { name = "copilot", priority = 85 },
              { name = "async_path", priority = 80 },
              { name = "spell", priority = 70 },
              { name = "fuzzy_buffer", priority = 60 },
              { name = "luasnip", priority = 50 },
              { name = "cmp_zotcite", priority = 40 },
            },
            window = {
              documentation = cmp.config.window.bordered(),
            },
            sorting = {
              priority_weight = 1.0,
              comparators = {
                cmp.config.compare.locality,
                cmp.config.compare.recently_used,
                cmp.config.compare.score,
                cmp.config.compare.offset,
                cmp.config.compare.order,
              },
            },
            mapping = {
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { "i", "s" }),

              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),

              ["<CR>"] = cmp.mapping({
                i = function(fallback)
                  if cmp.visible() and cmp.get_active_entry() then
                    cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
                  else
                    fallback()
                  end
                end,
                s = cmp.mapping.confirm({ select = true }),
                c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
              }),
              ['<C-y>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              }),
            },
          })
        '';
      }
    ];
  };
}
