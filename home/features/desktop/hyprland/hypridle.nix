{
  pkgs,
  lib,
  ...
}: let
  my_lock_cmd = "noctalia msg session lock";

  suspendScript = pkgs.writeShellScript "suspend-script" ''
    BAT=$(echo /sys/class/power_supply/BAT*)
    BAT_STATUS="$BAT/status"

    battery_status=$(cat "$BAT_STATUS")
    if [[ "$battery_status" == "Discharging" ]]; then
      ${pkgs.systemd}/bin/systemctl suspend
    else
      # TODO: If heavy computation is detected, reset hypridle timeout
      # Send to power monitor to switch to "power-saver": `powerprofilesctl set "power-saver"`
      notify-send "Request power-monitor to swtich to power-saver"
    fi
  '';

  brillo =
  let
    # Fetch source from GitHub
    src = pkgs.fetchFromGitHub {
      owner = "crisbour";
      repo = "brillo"; # Example repo
      rev = "v2.0";   # Tag or commit hash
      sha256 = "sha256-aKl09vbggARBuPkYZO0XT0+0re/80qFPKiTS/rfvI7k=";
    };
  in
  pkgs.rustPlatform.buildRustPackage {
    pname = "brillo-oxide";
    version = "2.0.0";

    inherit src;

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };

    # Optional: Extra build inputs if your project needs system libraries (e.g., openssl, pkgconfig)
    buildInputs = [ pkgs.openssl pkgs.pkg-config ];

    # Optional: Environment variables for build scripts
    # OPENSSL_DIR = "${pkgs.openssl.dev}";

    meta = {
      description = "brillo Rust project rewrite for external monitors control";
      license = pkgs.lib.licenses.mit;
      mainProgram = "brillo"; # The name of the binary produced
    };
  };
in {
  home.packages = [
    brillo
  ];
  # screen idle
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        # Message noctalia to lock instead of causing a ping-pong dbus lock request between Noctlia and hypridle
        # Otherwise this causes infinite lock loop with Noctalia
        # Fix found: https://github.com/ryan4yin/nix-config/blob/96fc0e3502d896437af8df90a63b3ceb44fe9196/home/linux/gui/base/hypridle/default.nix#L64
        lock_cmd = my_lock_cmd;
        before_sleep_cmd = my_lock_cmd;
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 120; # 2 min
          # save the current brightness and dim the screen
          on-timeout = "${brillo}/bin/brillo -O; ${brillo}/bin/brillo -S 5% -t monitor; ${brillo}/bin/brillo -S 5%;";
          # brighten the screen
          on-resume = "${brillo}/bin/brillo -I";
        }
        {
          timeout = 300; # 5 min
          on-timeout = "hyprctl dispatch 'hl.dsp.dpms({action = \"off\"})'";        # screen off when timeout has passed
          on-resume = "hyprctl dispatch 'hl.dsp.dpms({action = \"on\"})'";          # screen on when activity is detected after timeout has fired.
        }
        {
          timeout = 600; # 10 min suspend
          on-timeout = suspendScript.outPath;
          #condition_cmd = "test if busy computation";
          #condition_retry = 300;
        }
      ];
    };
  };

  # TODO: Figure out a solution for heavy computation deference of power profile switch when on AC
  # checkout: https://github.com/thrawny/dotfiles/blob/c743dd1996508200615a1684fd2eab526f972e32/nix/home/nixos/hypridle.nix#L29
}
