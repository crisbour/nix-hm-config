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
      vim-matchup # Scope jump to begin and end with `g%`, `[%`, `]%`, `z%`
      nvim-treesitter-context # Show code context at the top

      {
        # Docs: https://nixos.wiki/wiki/Treesitter
        type = "lua";
        #plugin = nvim-treesitter.withAllGrammars;
        plugin = nvim-treesitter.withPlugins (p: [
          p.bash
          p.bash
          p.c
          p.comment
          p.cpp
          p.diff
          p.ebnf
          p.git_config
          p.git_rebase
          p.gitattributes
          p.gitignore
          p.go
          p.gomod
          p.gosum
          p.gowork
          p.html
          p.javascript
          p.json
          p.json5
          p.julia
          p.kotlin
          p.latex
          p.lua
          p.markdown
          p.markdown
          p.matlab
          p.nix
          p.ocaml
          p.proto
          p.python
          p.rust
          p.sql
          p.systemverilog
          p.tsx
          p.vim
          p.vimdoc
          p.xml
          p.yaml
          p.zig
        ]);
        config = ''
          require('nvim-treesitter').setup({
            opts = {
                ensure_installed = { "lua", "vim", "vimdoc", "query", "python", "c", "cpp", "markdown", "markdown_inline", "csv", "json", "rust"},
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
                injections = { enable = true }, -- Critical for code blocks inside Markdown
            },
          })
        '';
      }
    ];
  };
}
