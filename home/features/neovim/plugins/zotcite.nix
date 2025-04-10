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

    withPython3 = true;

    extraPython3Packages = p: with p; [
      pyyaml
      pynvim
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
