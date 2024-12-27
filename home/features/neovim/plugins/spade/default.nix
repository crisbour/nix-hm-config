{ pkgs, ... }:
let
  spade-language-server = import ./spade-ls.nix { inherit pkgs; };
in
{
  #TODO: If necessary create nvim flake: https://primamateria.github.io/blog/neovim-nix/
  imports = [
    # Custom plugins
    ## Spade-lang syntax higlight
    ./spade-vim.nix
  ];

  home.packages = [
    spade-language-server
  ];

  programs.neovim = {
    extraPackages = with pkgs; [
      spade-language-server
    ];
    plugins = with pkgs.vimPlugins; [
      {
        type = "lua";
        plugin = nvim-lspconfig;
        config = ''
          vim.tbl_deep_extend('keep', lspconfig, {
            spadels = {
              cmd = { 'spade-language-server' },
              filetypes = 'spade',
              name = 'spadels',
            }
          })
        '';
      }
    ];
  };
}
