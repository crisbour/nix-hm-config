{ pkgs, ...}:
let
  asciidoc-preview = pkgs.vimUtils.buildVimPlugin rec {
    version = "main";
    pname = "nvim-asciidoc-preview";
    src = pkgs.fetchFromGitHub {
      owner = "tigion";
      repo = "nvim-asciidoc-preview";
      rev = "b12e113b5f7e7522b4e412213d5498cc529f2628";
      sha256 = "sha256-HxyVz9qpVm1a9iBu1SDej4Sv3V5daCvHOCHFf/6F0WU=";
    };
    buildInputs = [pkgs.nodejs];
    meta.homepage = "https://github.com/tigion/nvim-asciidoc-preview";
  };
in
{

  home.packages = [
    pkgs.asciidoctor-with-extensions
  ];

  programs.neovim = {

    withNodeJs = true;

    plugins = [
      {
        type = "lua";
        plugin = asciidoc-preview;
        config = ''
          require('asciidoc-preview').setup({
            server = {
              converter = 'js'
            },
            preview = {
              position = 'current',
            },
          })
        '';
      }
    ];
  };

}

