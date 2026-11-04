{ inputs, pkgs, ... }:
{
  stylix.targets.yazi.enable = true;
  stylix.targets.yazi.colors.enable = false;

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.unstable.yazi;
    # package = pkgs.yazi-unwrapped;

    settings = {
      manager = {
        linemode = "size";
        show_hidden = true;
        show_symlink = true;
        sort_by = "natural";
        sort_dir_first = true;
        sort_reverse = false;
        sort_sensitive = false;
      };
    };

    plugins = with pkgs.yaziPlugins; {
      full-border = full-border;
      starship = starship;
      mount = mount;
      diff = diff;
      bookmarks = bookmarks;
      piper = piper;
      ouch = ouch;
    };

    initLua = builtins.readFile ./init.lua;

    settings = {
      prepend_previewers = [
        # archive previewers
        {
          mime = "application/*zip";
          run = "ouch";
        }
        {
          mime = "application/x-tar";
          run = "ouch";
        }
        {
          mime = "application/x-bzip2";
          run = "ouch";
        }
        {
          mime = "application/x-7z-compressed";
          run = "ouch";
        }
        {
          mime = "application/x-rar";
          run = "ouch";
        }
        {
          mime = "application/x-xz";
          run = "ouch";
        }
        {
          mime = "application/xz";
          run = "ouch";
        }

        # markdown with glow
        {
          url = "*.md";
          run = ''
            piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark "$1"
          '';
        }

        {
          url = "*.csv";
          run = ''piper -- bat -p --color=always "$1"'';
        }
      ];
    };
  };

  #xdg.configFile."yazi/init.lua".text = ''
  #  require("full-border"):setup()
  #'';
}
