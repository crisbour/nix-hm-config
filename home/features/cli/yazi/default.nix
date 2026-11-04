{ inputs, pkgs, ... }:
{
  stylix.targets.yazi.enable = true;
  stylix.targets.yazi.colors.enable = false;

  home.packages = with pkgs; [
    glow
    ouch
  ];

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
      git = git;
      starship = starship;
      mount = mount;
      diff = diff;
      bookmarks = bookmarks;
      piper = piper;
      ouch = ouch;
    };

    initLua = builtins.readFile ./init.lua;

    settings = {
      plugin = {
        prepend_fetchers = [
          {
            url   = "*";
            run   = "git";
            group = "git";
          }
          {
            url   = "*/";
            run   = "git";
            group = "git";
          }
        ];
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

    keymap = {
      mgr = {
        prepend_keymap = [
          {
            on = "M";
            run = "plugin mount";
            desc = "Mount drives";
          }

          #{
          #  on = "u";
          #  run = "plugin restore";
          #  desc = "Restore last deleted files/folders";
          #}

          # compress.yazi
          {
            on = [
              "-"
              "c"
            ];
            run = "plugin compress";
            desc = "Archive selected files";
          }
          {
            on = [
              "-"
              "p"
            ];
            run = "plugin compress -p";
            desc = "Archive with password";
          }
          {
            on = [
              "-"
              "h"
            ];
            run = "plugin compress -ph";
            desc = "Archive with password and header";
          }
          {
            on = [
              "-"
              "l"
            ];
            run = "plugin compress -l";
            desc = "Archive with compression level";
          }
        ];
      };
    };
  };

  #xdg.configFile."yazi/init.lua".text = ''
  #  require("full-border"):setup()
  #'';
}
