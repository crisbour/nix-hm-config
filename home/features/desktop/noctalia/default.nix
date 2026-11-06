{pkgs, inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
    ./enchanted-sound.nix
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      # =============================================================================
      # BAR CONFIGURATION
      # =============================================================================
      bar.default = {
        position = "top";
        thickness = 32;
        scale = 1.25;

        start = [
          "launcher"
          "wallpaper"
          "workspaces"
          "tray"
          "media"
        ];

        center = [
          "clock"
          "weather"
        ];

        end = [
          "cpu"
          "notifications"
          "clipboard"
          "network"
          "bluetooth"
          "volume"
          "control-center"
          "battery"
          "keyboard_layout"
          "session"
        ];
      };

      audio = {
        enable_sounds = true;
        sound_theme = "Enchanted";
        sound_volume = 0.5;
      };

      # =============================================================================
      # SHELL CONFIGURATION
      # =============================================================================
      shell = {
        font_family = "NotoSans NF";
        polkit_agent = true;
        telemetry_enabled = true;
        corner_radius_scale = 0.0;
        launcher.glyph = "mushroom"; # TODO: Change to nix logo
        workspaces.capsule_radius = 0;
      };

      # for external monitors
      brightness = {
        enable_ddcutil = true;
        minimum_brightness = 0.01;
      };


      # =============================================================================
      # THEME CONFIGURATION
      # =============================================================================
      theme = {
        mode   = "dark";   # stay dark; no day/night switching (avoids clashing with the wallpaper switcher)
        source = "builtin";
        builtin = "Eldritch";
        # Palette generation scheme. "dysfunctional" is Noctalia's "Disfunctional"
        # scheme (replaces the built-in default "M3 Tonal Spot").
        wallpaper_scheme = "dysfunctional";

        templates = {
          enable_builtin_templates = true;
          builtin_ids              = [ "kitty" "gtk3" "gtk4" ];
        };
      };

      # =============================================================================
      # LOCATION CONFIGURATION
      # =============================================================================
      location = {
        address = "Edinburgh";
      };

      # =============================================================================
      # CALENDAR CONFIGURATION
      # =============================================================================
      # show events from online calendar accounts
      calendar.enabled = true;

      # =============================================================================
      # LOCKSCREEN CONFIGURATION
      # =============================================================================
      lockscreen = {
        enabled = true;
        blurred_desktop = true;
        grace_period_seconds = 15;
        transition = [
          "disc"
          "fade"
          "melt"
          "vortex"
          "wipe"
          "zoom"
        ];
        transition_duration = 800;
      };

      # =============================================================================
      # WIDGET CONFIGURATIONS
      # =============================================================================
      widget = {
        clock = {
          format = "{:%H:%M}  {: %a - %e %b} ";
          timezone = "Europe/London";
          tooltip_format = "{:%A, %B %d, %Y}";
        };

        cpu = {
          label_min_width = 1;
          show_cpu_cores = true;
        };

        network = {
          peek = true;
          scale = 1.0;
          font_scale = 1.0;
        };

        brightness = {
          font_scale = 1.0;
        };
      };

      # =============================================================================
      # PLUGINS CONFIGURATION
      # =============================================================================
      plugins = {
        enabled = [
          "samuelskovbakke/calculator-plus"
          "noctalia/screen_recorder"
        ];
      };

      # =============================================================================
      # WALLPAPER CONFIGURATION
      # =============================================================================
      wallpaper = {
        enabled             = true;
        fill_mode           = "crop";
      };
    };
  };

  home.packages = with pkgs; [
    ddcutil # for external monitor brightness control
  ];

}
