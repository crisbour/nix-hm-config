{ pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    settings = {
      # autostart
      exec-once = [
        # "hash dbus-update-activation-environment 2>/dev/null"
        "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

        "nm-applet &"
        "poweralertd &"
        "waybar &"
        "swaync &"
        "hyprctl setcursor Bibata-Modern-Ice 24 &"
        "wayvnc $(tailscale ip --4)"

        #"wl-paste --watch cliphist store &"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "wl-clip-persist --clipboard both &"

        "hyprlock"
      ];

      input = {
        kb_model = "pc104";
        kb_layout = "us";
        kb_options = "terminate:ctrl_alt_bksp";
        numlock_by_default = false;
        follow_mouse = 1;
        float_switch_override_focus = 0;
        mouse_refocus = 0;
        sensitivity = 0;
        touchpad = {
          natural_scroll = false;
        };
      };

      general = {
        "$mainMod" = "SUPER";
        layout = "dwindle";
        gaps_in = 3;
        gaps_out = 6;
        border_size = 2;
        no_border_on_floating = false;
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = false;
        enable_swallow = true;
        focus_on_activate = true;
        new_window_takes_over_fullscreen = 2;
        middle_click_paste = true;
      };

      dwindle = {
        # no_gaps_when_only = false;
        force_split = 0;
        special_scale_factor = 1.0;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        pseudotile = "yes";
        preserve_split = "yes";
      };

      master = {
        new_status = "master";
        special_scale_factor = 1;
        # no_gaps_when_only = false;
      };

      decoration = {
        rounding = 0;
        # active_opacity = 0.90;
        # inactive_opacity = 0.90;
        # fullscreen_opacity = 1.0;

        blur = {
          enabled = true;
          size = 3;
          passes = 2;
          brightness = 1;
          contrast = 1.4;
          ignore_opacity = true;
          noise = 0;
          new_optimizations = true;
          xray = true;
        };

        shadow = {
          enabled = true;

          ignore_window = true;
          offset = "0 2";
          range = 20;
          render_power = 3;
          #color = "rgba(00000055)";
        };
      };

      animations = {
        enabled = true;

        bezier = [
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "fade_curve, 0, 0.55, 0.45, 1"
        ];

        animation = [
          # name, enable, speed, curve, style

          # Windows
          "windowsIn,   0, 4, easeOutCubic,  popin 20%" # window open
          "windowsOut,  0, 4, fluent_decel,  popin 80%" # window close.
          "windowsMove, 1, 2, fluent_decel, slide" # everything in between, moving, dragging, resizing.

          # Fade
          "fadeIn,      1, 3,   fade_curve" # fade in (open) -> layers and windows
          "fadeOut,     1, 3,   fade_curve" # fade out (close) -> layers and windows
          "fadeSwitch,  0, 1,   easeOutCirc" # fade on changing activewindow and its opacity
          "fadeShadow,  1, 10,  easeOutCirc" # fade on changing activewindow for shadows
          "fadeDim,     1, 4,   fluent_decel" # the easing of the dimming of inactive windows
          # "border,    1, 2.7, easeOutCirc"  # for animating the border's color switch speed
          # "borderangle, 1, 30,  fluent_decel, once" # for animating the border's gradient angle - styles: once (default), loop
          "workspaces,  1, 4,   easeOutCubic, fade" # styles: slide, slidevert, fade, slidefade, slidefadevert
        ];
      };

      bind = [
        # show keybinds list
        "SUPER, F1, exec, show-keybinds"

        # keybindings
        "SUPER, Q, killactive,"
        "SUPER, F, fullscreen, 0"
        "SUPER SHIFT, F, fullscreen, 1"
        "SUPER, Space, exec, togglefloating"
        "SUPER, X, togglesplit,"
        "SUPER, O, exec, toggle_oppacity"
        "SUPER SHIFT, B, exec, toggle_waybar"
        ## terminal
        "SUPER, Return, exec, kitty"
        "SUPER SHIFT, Return, exec, [fullscreen] kitty"
        "ALT, Return, exec, [float; size 1111 700] ghostty"

        ## file explorer
        "SUPER, E, exec, nemo"
        "ALT, E, exec, hyprctl dispatch exec '[float; size 1111 700] nemo'"
        "SUPER SHIFT, E, exec, hyprctl dispatch exec '[float; size 1111 700] ghostty -e yazi'"

        ## browser
        "SUPER, B, exec, hyprctl dispatch exec '[workspace 1 silent] zen'"

        ## utils
        # FIXME: How to add multiple x11 sessions without mounting all the sockets?
        "SUPER SHIFT, W,exec, x11-portal" # Open an x11 window in wayland with weston for one app
        "SUPER, N, exec, swaync-client -t -sw"
        "CTRL SHIFT, Escape, exec, hyprctl dispatch exec '[workspace 11] resources'"
        # "SUPER SHIFT, W, exec, vm-start"

        ## Not frequently used, perhaps remove?
        "SUPER, C ,exec, hyprpicker -a"
        "SUPER CTRL SHIFT, S, exec, ${pkgs.qrtool}/bin/qrtool decode $(${pkgs.grimblast}/bin/grimblast --freeze save area) | ${pkgs.wl-clipboard}/bin/wl-copy" # Scans QR code and copies data to clipboard
#"SUPER SHIFT, W,exec, hyprctl dispatch exec '[float; size 925 615] waypaper'"
        "SUPER SHIFT, D, exec, webcord --enable-features=UseOzonePlatform --ozone-platform=wayland"
        "SUPER SHIFT, S, exec, hyprctl dispatch exec '[workspace 5 silent] SoundWireServer'"

        ## Lock/Suspend ...
        "SUPER, Escape, exec, swaylock"
        "ALT, Escape, exec, hyprlock"
        "SUPER SHIFT, Escape, exec, power-menu" # Using rofi

        ## Rofi
        "SUPER, D, exec, pkill rofi || rofi -show drun"
        "SUPER, PERIOD, exec, bemoji" # Using rofi
        "SUPER, W, exec, wallpaper-picker"
        "SUPER SHIFT, C, exec, rofi -show calc"
        "SUPER SHIFT, P, exec, rofi-pass"
        ### clipboard manager
        "SUPER, V, exec, cliphist list | rofi -dmenu -theme-str 'window {width: 50%;} listview {columns: 1;}' | cliphist decode | wl-copy"

        ## screenshot
        ",Print, exec, screenshot --copy"
        "SUPER, Print, exec, screenshot --save"
        #"SUPER SHIFT, Print, exec, screenshot --swappy"
        "SUPER SHIFT, Print, exec, screenshot --satty"
        "SUPER ALT, Print, exec, pix2tex"
        "SUPER CTRL, Print, exec, screenshot --ocr"

        ## switch focus
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"
        "SUPER, h, movefocus, l"
        "SUPER, j, movefocus, d"
        "SUPER, k, movefocus, u"
        "SUPER, l, movefocus, r"

        ## switch workspace
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        ## same as above, but switch to the workspace
        "SUPER SHIFT, 1, movetoworkspacesilent, 1" # movetoworkspacesilent
        "SUPER SHIFT, 2, movetoworkspacesilent, 2"
        "SUPER SHIFT, 3, movetoworkspacesilent, 3"
        "SUPER SHIFT, 4, movetoworkspacesilent, 4"
        "SUPER SHIFT, 5, movetoworkspacesilent, 5"
        "SUPER SHIFT, 6, movetoworkspacesilent, 6"
        "SUPER SHIFT, 7, movetoworkspacesilent, 7"
        "SUPER SHIFT, 8, movetoworkspacesilent, 8"
        "SUPER SHIFT, 9, movetoworkspacesilent, 9"
        "SUPER SHIFT, 0, movetoworkspacesilent, 10"
        "SUPER CTRL, c, movetoworkspace, empty"

        ## Move workspace to monitor
        "CTRL SUPER, j, movecurrentworkspacetomonitor, l"
        "CTRL SUPER, k, movecurrentworkspacetomonitor, r"

        ## window control
        "SUPER SHIFT, left, movewindow, l"
        "SUPER SHIFT, right, movewindow, r"
        "SUPER SHIFT, up, movewindow, u"
        "SUPER SHIFT, down, movewindow, d"
        "SUPER SHIFT, h, movewindow, l"
        "SUPER SHIFT, j, movewindow, d"
        "SUPER SHIFT, k, movewindow, u"
        "SUPER SHIFT, l, movewindow, r"

        "SUPER CTRL, left, resizeactive, -80 0"
        "SUPER CTRL, right, resizeactive, 80 0"
        "SUPER CTRL, up, resizeactive, 0 -80"
        "SUPER CTRL, down, resizeactive, 0 80"
        "SUPER CTRL, h, resizeactive, -80 0"
        "SUPER CTRL, j, resizeactive, 0 80"
        "SUPER CTRL, k, resizeactive, 0 -80"
        "SUPER CTRL, l, resizeactive, 80 0"

        ## media and volume controls
        # ",XF86AudioMute,exec, pamixer -t"
        ",XF86AudioPlay,exec, playerctl play-pause"
        ",XF86AudioNext,exec, playerctl next"
        ",XF86AudioPrev,exec, playerctl previous"
        ",XF86AudioStop,exec, playerctl stop"

        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up, workspace, e-1"

        "SUPER, m, workspace, m-1"
        "SUPER, comma, workspace, m+1"
      ];

      # # binds active in lockscreen
      # bindl = [
      #   # laptop brigthness
      #   ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      #   ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      #   "SUPER, XF86MonBrightnessUp, exec, brightnessctl set 100%+"
      #   "SUPER, XF86MonBrightnessDown, exec, brightnessctl set 100%-"
      # ];

      # # binds that repeat when held
      # binde = [
      #   ",XF86AudioRaiseVolume,exec, pamixer -i 2"
      #   ",XF86AudioLowerVolume,exec, pamixer -d 2"
      # ];

      # mouse binding
      bindm = [
        "SUPER, mouse:272, movewindow"
          "SUPER, mouse:273, resizewindow"
      ];

      # windowrule
      windowrule = [
        "float, class:oculante"
        "float, class:imv"
        "float, class:mpv"
        "float, class:audacious"
        "pin, class:rofi"
        "pin, class:waypaper"
        "tile, class:neovide"
        "idleinhibit focus, class:mpv"
        "float, class:udiskie"
        "float,title:^(Transmission)$"
        "float,title:^(Volume Control)$"
        "float,title:^(Firefox — Sharing Indicator)$"
        "move 0 0,title:^(Firefox — Sharing Indicator)$"
        "size 700 450,title:^(Volume Control)$"
        "move 40 55%,title:^(Volume Control)$"
      ];

      # windowrulev2
      windowrulev2 = [
        "float, title:^(Picture-in-Picture)$"
        "opacity 1.0 override 1.0 override, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        "opacity 1.0 override 1.0 override, title:^(.*imv.*)$"
        "opacity 1.0 override 1.0 override, title:^(.*mpv.*)$"
        "opacity 1.0 override 1.0 override, class:(Unity)"
        "opacity 1.0 override 1.0 override, class:(brave)"
        "opacity 1.0 override 1.0 override, class:(okular)"
        "workspace 1, class:^(zen)$"
        "workspace 3, class:^(okular)$"
        "workspace 4, class:^(Gimp-2.10)$"
        "workspace 5, class:^(Spotify)$"
        "workspace 8, class:^(com.obsproject.Studio)$"
        "workspace 10, class:^(discord)$"
        "workspace 10, class:^(WebCord)$"
        "idleinhibit focus, class:^(mpv)$"
        "idleinhibit fullscreen, class:^(firefox)$"
        "float,class:^(org.gnome.Calculator)$"
        "float,class:^(waypaper)$"
        "float,class:^(zenity)$"
        "size 850 500,class:^(zenity)$"
        "float,class:^(org.gnome.FileRoller)$"
        "float,class:^(pavucontrol)$"
        "float,class:^(SoundWireServer)$"
        "float,class:^(.sameboy-wrapped)$"
        "float,class:^(file_progress)$"
        "float,class:^(confirm)$"
        "float,class:^(dialog)$"
        "float,class:^(download)$"
        "float,class:^(notification)$"
        "float,class:^(error)$"
        "float,class:^(confirmreset)$"
        "float,title:^(Open File)$"
        "float,title:^(File Upload)$"
        "float,title:^(branchdialog)$"
        "float,title:^(Confirm to replace files)$"
        "float,title:^(File Operation Progress)$"

        # No gaps when only
        "bordersize 0, floating:0, onworkspace:w[t1]"
        "rounding 0, floating:0, onworkspace:w[t1]"
        "bordersize 0, floating:0, onworkspace:w[tg1]"
        "rounding 0, floating:0, onworkspace:w[tg1]"
        "bordersize 0, floating:0, onworkspace:f[1]"
        "rounding 0, floating:0, onworkspace:f[1]"

        "center, floating: 1"

        # Remove context menu transparency in chromium based apps
        "opaque,class:^()$,title:^()$"
        "noshadow,class:^()$,title:^()$"
        "noblur,class:^()$,title:^()$"
      ];

      # No gaps when only
      workspace = [
        "w[t1], gapsout:0, gapsin:0"
        "w[tg1], gapsout:0, gapsin:0"
        "f[1], gapsout:0, gapsin:0"
      ];
    };

  };
}
