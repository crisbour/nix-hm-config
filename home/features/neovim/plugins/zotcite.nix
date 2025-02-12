{ pkgs, ...}:
let
  zotcite = pkgs.vimUtils.buildVimPlugin rec {
    version = "master";
    pname = "zotcite-${version}";
    src = pkgs.fetchFromGitHub {
      owner = "jalvesaq";
      repo = "zotcite";
      rev = "e8170010e4d80be5edfc3c1935b2b6e6c33e6ba5";
      sha256 = "sha256-FM1kprCOXIvKwDdjkrtn/M9u6sNIo82tmIYP+DzIGac=";
    };
    meta.homepage = "https://github.com/jalvesaq/zotcite";
  };
in
{

  programs.neovim = {

    extraPackages = [
      # WARN: it depends on nvim-treesitter and telescope.nvim While I have
      # these as part of my setup, how to minimally incorporate those here to
      # assure self sufficient attribute for zotcite?
    ];

    plugins = [
      {
        type = "lua";
        plugin = zotcite;
        config = ''
          require("zotcite").setup({
              -- your options here (see doc/zotcite.txt)
          })
        '';
      }
    ];
  };


}
