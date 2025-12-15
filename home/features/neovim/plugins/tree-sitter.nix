# Tree Sitter
{ pkgs, ... }:
with pkgs;
let
  luaPlugin = pkg: {
    type = "lua";
    plugin = pkg;
  };
in {
  home.packages = [
    pkgs.asciidoc-full
  ];
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      (nvim-treesitter-parsers.bash)
      (nvim-treesitter-parsers.c)
      (nvim-treesitter-parsers.comment)
      (nvim-treesitter-parsers.cpp)
      (nvim-treesitter-parsers.diff)
      (nvim-treesitter-parsers.git_config)
      (nvim-treesitter-parsers.git_rebase)
      (nvim-treesitter-parsers.gitattributes)
      (nvim-treesitter-parsers.gitignore)
      (nvim-treesitter-parsers.go)
      (nvim-treesitter-parsers.gomod)
      (nvim-treesitter-parsers.gosum)
      (nvim-treesitter-parsers.gowork)
      (nvim-treesitter-parsers.html)
      (nvim-treesitter-parsers.kotlin)
      (nvim-treesitter-parsers.javascript)
      (nvim-treesitter-parsers.javascript)
      (nvim-treesitter-parsers.julia)
      (nvim-treesitter-parsers.json)
      (nvim-treesitter-parsers.json5)
      (nvim-treesitter-parsers.latex)
      (nvim-treesitter-parsers.lua)
      (nvim-treesitter-parsers.markdown)
      (nvim-treesitter-parsers.markdown_inline)
      (nvim-treesitter-parsers.matlab)
      (nvim-treesitter-parsers.nix)
      (nvim-treesitter-parsers.ocaml)
      (nvim-treesitter-parsers.proto)
      (nvim-treesitter-parsers.python)
      (nvim-treesitter-parsers.rust)
      (nvim-treesitter-parsers.sql)
      (nvim-treesitter-parsers.tsx)
      (nvim-treesitter-parsers.vim)
      (nvim-treesitter-parsers.vimdoc)
      (nvim-treesitter-parsers.systemverilog)
      (nvim-treesitter-parsers.xml)
      (nvim-treesitter-parsers.yaml)
      (nvim-treesitter-parsers.zig)

      vim-matchup # Scope jump to begin and end with `g%`, `[%`, `]%`, `z%`

      nvim-treesitter-context # Show code context at the top

      {
        type = "lua";
        plugin = nvim-treesitter;
        config = ''
          require('nvim-treesitter.configs').setup({
            indent = {
              enable = true
            },
            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            matchup = { enable = true },
          })

        '';
      }
    ];
  };
}
