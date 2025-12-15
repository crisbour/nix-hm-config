{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    themeFile = "gruvbox-dark-hard";
    # Inspired from https://github.com/maximbaz/dotfiles/blob/e764eb7f0592547bcc0890c7a704bda30b3296a8/modules/common/kitty.nix#L2

    settings = {
      allow_remote_control = true;
      close_on_child_death = true;
      cursor_shape = "beam";
      enable_audio_bell = false;
      listen_on = if pkgs.stdenv.isLinux then "unix:@kitty" else "unix:/tmp/kitty";
      mouse_hide_wait = 0;
      scrollback_lines = 100000;
      strip_trailing_spaces = "always";
      touch_scroll_multiplier = 20;

      #macos_option_as_alt = true;
      #macos_quit_when_last_window_closed = true;
      #macos_show_window_title_in = "window";
      remember_window_size = false;
      initial_window_width = 1000;
      initial_window_height = 600;
      confirm_os_window_close=0;
    };

    # FIXME: No idea what these shortcuts are, must have inhereted them from somewhere. Cleanup!!!
    keybindings = {
      "kitty_mod+b" = "launch --type overlay --stdin-source=@screen_scrollback hx";
      "kitty_mod+n" = if pkgs.stdenv.isLinux then "new_tab_with_cwd cglaunch kitty --detach" else "new_os_window_with_cwd";
      "kitty_mod+u" = '' launch --type window --allow-remote-control sh -c 'kitty @ send-text -m id:1 "\e[200~$(emoji-dmenu -k overlay)\e[201~"' '';
      "kitty_mod+г" = '' launch --type window --allow-remote-control sh -c 'kitty @ send-text -m id:1 "\e[200~$(emoji-dmenu -k overlay)\e[201~"' '';
      "kitty_mod+i" = '' launch --type window --allow-remote-control sh -c 'kitty @ send-text -m id:1 "\e[200~$(wl-clipboard-manager dmenu -k overlay)\e[201~"' '';
      "kitty_mod+ш" = '' launch --type window --allow-remote-control sh -c 'kitty @ send-text -m id:2 "\e[200~$(wl-clipboard-manager dmenu -k overlay)\e[201~"' '';
      "kitty_mod+0" = "change_font_size all 0";
      "kitty_mod+с" = "copy_to_clipboard";
      "kitty_mod+v" = "paste_from_clipboard";
      "alt+1" = "disable_ligatures_in active always";
      "alt+2" = "disable_ligatures_in active never";
      "alt+3" = "disable_ligatures_in active cursor";
    };
  };
}
