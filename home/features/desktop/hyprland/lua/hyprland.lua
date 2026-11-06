-- Inspired from: https://github.com/ItzDerock/dotfiles/blob/8428e463eb7fee89ce2ccf9097f6f6a51b06b111/home-manager/hyprland.nix#L173

-- Load monitor config from ~/.config/hypr/monitors.lua
-- Create this file with hl.monitor({}) calls for your setup
pcall(require, "monitors")

-- local hs = require("hyprsplit")
-- local clamshell = require("clamshell")
local mod = "SUPER"

hl.config({
  general = {
    layout = "dwindle",
    gaps_in = 1,
    gaps_out = 0,
    border_size = 2,
    -- ["col.active_border"] = "rgb(101415)",
    -- ["col.inactive_border"] = "rgb(101415)",
  },
  scrolling = {
    follow_focus = false,
  },
  decoration = {
    rounding = 0,
    blur = {
      enabled = true,
      size = 3,
      passes = 2,
      brightness = 1,
      contrast = 1.4,
      ignore_opacity = true,
      noise = 0,
      new_optimizations = true,
      xray = true,
    },
  },
  animations = {
    enabled = true,
  },
  input = {
    kb_layout = "us",
    sensitivity = 0, -- mouse sensitivity
    accel_profile = "flat",
    follow_mouse = 1,
    float_switch_override_focus = 0,
    touchpad = {
      natural_scroll = false,
      disable_while_typing = true,
      scroll_factor = 0.5,
    },
  },
  misc = {
    disable_hyprland_logo = true,
    force_default_wallpaper = 0,
    enable_swallow = true,
    focus_on_activate = true,
    middle_click_paste = true,

    -- child windows follow parent wksp
    initial_workspace_tracking = 1,
  },
  dwindle = {
    force_split = 0,
    use_active_for_splits = true,
    preserve_split = true,
    smart_split = true,
  },
  debug = {
    disable_logs = true,
  },
  xwayland = {
    force_zero_scaling = true,
  },

  --plugin = {
  --  hyprexpo = {
  --    columns = 3,
  --    gaps_in = 5,
  --    gaps_out = 0,
  --    bg_col = "rgb(111111)",
  --    workspace_method = "center current",
  --    gesture_distance = 200,
  --    cancel_key = "escape",
  --    show_cursor = 1,
  --  },
  --},
})


-- Bezier curves (https://github.com/vyrx-dev/dotfiles)
hl.curve("water", { type = "bezier", points = { { 0.22, 0.9 }, { 0.36, 1.0 } } })
hl.curve("flow", { type = "bezier", points = { { 0.25, 0.1 }, { 0.25, 1.0 } } })
hl.curve("ripple", { type = "bezier", points = { { 0.33, 0.0 }, { 0.2, 1.0 } } })
hl.curve("stream", { type = "bezier", points = { { 0.4, 0.0 }, { 0.4, 1.0 } } })
hl.curve("cascade", { type = "bezier", points = { { 0.19, 1.0 }, { 0.22, 1.0 } } })
hl.curve("md3_standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })
hl.curve("md3_accel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.15 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 3.0, bezier = "water" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2.5, bezier = "cascade", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.4, bezier = "stream", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1.6, bezier = "flow" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.4, bezier = "water" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2.0, bezier = "cascade" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.8, bezier = "ripple" })
hl.animation({ leaf = "fadeDim", enabled = true, speed = 2.0, bezier = "water" })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 1.4, bezier = "flow" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 1.5, bezier = "overshot", style = "popin 80%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.3, bezier = "md3_accel", style = "popin 90%" })
hl.animation({ leaf = "layers", enabled = true, speed = 1.5, bezier = "md3_standard" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.5, bezier = "flow" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2.5, bezier = "water" })
hl.animation({ leaf = "border", enabled = true, speed = 2.9, bezier = "water" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 3.5, bezier = "flow" })

-- hl.device({
--   name = "img4100:00-4d49:4150-touchpad",
--   sensitivity = 0,
-- })

-- hl.gesture({
--   fingers = 3,
--   direction = "horizontal",
--   action = "workspace",
-- })

hl.on("hyprland.start", function()
  hl.exec_cmd("playerctld")
  hl.exec_cmd("dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

  hl.exec_cmd("nm-applet &")
  hl.exec_cmd("poweralertd &")

  hl.exec_cmd("wl-paste --type text --watch cliphist store")
  hl.exec_cmd("wl-paste --type image --watch cliphist store")
  hl.exec_cmd("wl-clip-persist --clipboard both &")

  hl.exec_cmd("thunderbird")

  -- hyprpolkitagent
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
end)

-- Mousbinds
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Keybinds list
hl.bind(mod .. " + F1", hl.dsp.exec_cmd("show-keybinds"))
-- Window management
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mod .. " + Space", hl.dsp.window.float())
hl.bind(mod .. " + X", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + O", hl.dsp.exec_cmd("toggle_oppacity"))
hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd("toggle_waybar"))
--hl.bind(mod .. " + E", hl.dsp.window.fullscreen())
--hl.bind(mod .. " + SHIFT + P", hl.dsp.window.pin())

---- Terminal
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("[fullscreen] kitty"))
hl.bind("ALT + RETURN", hl.dsp.exec_cmd("[float; size 1111 700] ghostty"))

-- File explorer
hl.bind("SUPER + E", hl.dsp.exec_cmd("kitty -e yazi"))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("nemo"))

hl.bind(mod .. " + Z", hl.dsp.layout("focus"))
hl.bind(mod .. " + G", hl.dsp.layout("promote"))

---- Apps
-- Browser
hl.bind(mod .. " + B", hl.dsp.exec_cmd("zen-beta"))
hl.bind(mod .. " + ALT + M", hl.dsp.workspace.toggle_special("mail"))

-- utils
hl.bind(mod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind("CTRL + SHIFT + ESCAPE", hl.dsp.exec_cmd("hyprctl dispatch exec '[workspace 11] btop'"))

-- Session / lock
--hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("caelestia shell drawers toggle session"))
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mod .. " + SHIFT + Escape", hl.dsp.exec_cmd("power-menu")) -- Using rofi

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("screenshot --copy"))
hl.bind(mod .. " + Print", hl.dsp.exec_cmd("screenshot --save"))
hl.bind(mod .. " + SHIFT + Print", hl.dsp.exec_cmd("screenshot --satty"))
hl.bind(mod .. " + ALT + Print", hl.dsp.exec_cmd("pix2tex"))
hl.bind(mod .. " + T", hl.dsp.exec_cmd("screenshot --ocr"))
-- QR scanner
hl.bind(mod .. " + CTRL + SHIFT + S", hl.dsp.exec_cmd("${pkgs.qrtool}/bin/qrtool decode $(${pkgs.grimblast}/bin/grimblast --freeze save area) | ${pkgs.wl-clipboard}/bin/wl-copy"))
-- TODO: Add recording screen for demos

-- Launchers
--hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("wofi -S drun -I"))
-- Rofi
hl.bind(mod .. " + D", hl.dsp.exec_cmd("pkill rofi || rofi -show drun"))
hl.bind(mod .. " + PERIOD", hl.dsp.exec_cmd("pkill rofi || rofi -show emoji"))
hl.bind(mod .. " + W", hl.dsp.exec_cmd("wallpaper-picker"))
hl.bind(mod .. " + SHIFT + P", hl.dsp.exec_cmd("rofi-pass"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -theme-str 'window {width: 50%;} listview {columns: 1;}' | cliphist decode | wl-copy"))

-- FIXME: Focus
hl.bind(mod .. " + LEFT",  hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + RIGHT", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + UP",    hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + DOWN",  hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + H",     hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J",     hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K",     hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L",     hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + M",     hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mod .. " + COMMA", hl.dsp.focus({ workspace = "m+1" }))


-- Switch workspace
for i = 1, 10 do
  local key = tostring(i % 10)
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
  --hl.bind(mod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end
--hl.bind(mod .. " + CTRL + C", hl.dsp.workspace.move_to("empty")) FIXME

-- Move workspace to monitor
hl.bind(mod .. " + CTRL + J",      hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mod .. " + CTRL + K",      hl.dsp.workspace.move({ monitor = "r" }))

-- Window movement
hl.bind(mod .. " + SHIFT + LEFT",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + RIGHT", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + UP",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + DOWN",  hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + H",     hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + J",     hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + K",     hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + L",     hl.dsp.window.move({ direction = "right" }))

-- Resize active window
hl.bind(mod .. " + CTRL + LEFT",   hl.dsp.window.resize({ x = -10, y = 0,   relative = true }))
hl.bind(mod .. " + CTRL + RIGHT",  hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }))
hl.bind(mod .. " + CTRL + UP",     hl.dsp.window.resize({ x = 0,   y = -10, relative = true }))
hl.bind(mod .. " + CTRL + DOWN",   hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }))
hl.bind(mod .. " + CTRL + H",      hl.dsp.window.resize({ x = -10, y = 0,   relative = true }))
hl.bind(mod .. " + CTRL + J",      hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }))
hl.bind(mod .. " + CTRL + K",      hl.dsp.window.resize({ x = 0,   y = -10, relative = true }))
hl.bind(mod .. " + CTRL + L",      hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }))
hl.bind(mod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
  hl.bind("H", hl.dsp.window.resize({ x = -10, y = 0,   relative = true }), { repeating = true })
  hl.bind("L", hl.dsp.window.resize({ x = 10,  y = 0,   relative = true }), { repeating = true })
  hl.bind("J", hl.dsp.window.resize({ x = 0,   y = -10, relative = true }), { repeating = true })
  hl.bind("K", hl.dsp.window.resize({ x = 0,   y = 10,  relative = true }), { repeating = true })
  hl.bind("Escape", hl.dsp.submap("reset"))
end)

-- Color picker
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -f hex -a"))
--hl.bind(mod .. " + ALT + C", hl.dsp.exec_cmd("hyprpicker -f hex -a -r"))

-- Alt+Tab
-- TODO: Evaluate the usefulness of this
hl.bind("ALT + Tab", function()
  hl.dispatch(hl.dsp.window.cycle_next())
  hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)
hl.bind("ALT + SHIFT + Tab", function()
  hl.dispatch(hl.dsp.window.cycle_next({ next = false }))
  hl.dispatch(hl.dsp.window.alter_zorder({ mode = "top" }))
end)

-- Hyprexpo plugin
--hl.bind(mod .. " + TAB", function()
--  hl.plugin.hyprexpo.expo("toggle")
--end)

-- Window swallowing
-- TODO: What is this?
hl.bind(mod .. " + CTRL + SHIFT + S", hl.dsp.window.toggle_swallow())

-- Volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { repeating = true, locked = true })

-- Media
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"),     { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"),     { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true })
-- TODO: Add keys for external monitor brightness control

-- Scrolling layout: column movement
--hl.bind(mod .. " + SHIFT + W", hl.dsp.layout("move -col"))
--hl.bind(mod .. " + SHIFT + E", hl.dsp.layout("move +col"))
--hl.bind(mod .. " + SHIFT + H", hl.dsp.layout("swapcol l once"))
--hl.bind(mod .. " + SHIFT + L", hl.dsp.layout("swapcol r once"))
--hl.bind(mod .. " + CTRL + H", hl.dsp.layout("move -col"))
--hl.bind(mod .. " + CTRL + L", hl.dsp.layout("move +col"))


-- Thunderbird lives on the mail special workspace, opened silently (no focus steal)
hl.window_rule({
  match = { class = "thunderbird" },
  workspace = "special:mail silent",
})

-- Organise apps workspace
hl.window_rule({
  match = { class = "(WebCord|discord)" },
  workspace = 10,
})

-- Window rules (tag-setters first, then tag-consumers)
hl.window_rule({
  match = { class = "(Impala|org.gnome.NautilusPreviewer|About|TUI.float|org.kde.kcalc)" },
  tag = "+floating-window",
})
hl.window_rule({
  match = { class = "(pavucontrol|org.gnome.FileRoller|SoundWireServer|file_progress)" },
  tag = "+floating-window",
})

-- Match initial titles: portal pickers can later change to "Files — <app>".
local filePickerTitle =
    "(?i)^((Open|Save)( Files?| Folders?| Directory| Documents?| Images?| Project| Workspace)?|Save As|"
    .. "(Select|Choose|Browse for) (a |an )?(Files?|Folders?|Directory|Directories|Documents?|Images?)|"
    .. "All Files|File (Chooser|Picker|Upload)|Upload Files?)([[:space:]]*[-–—:].*|[[:space:]]*[.]{3}|…)?$"

hl.window_rule({
  match = { initial_title = filePickerTitle },
  tag = "+file-picker",
})

hl.window_rule({
  match = {
    class = "(org.kde.dolphin)",
    initial_title = "^(Moving \u{2014} Dolphin)",
  },
  tag = "+floating-window",
})

hl.window_rule({
  match = { tag = "floating-window" },
  float = true,
  center = true,
  --size = { 800, 600 },
})

hl.window_rule({
  match = { tag = "file-picker" },
  float = true,
  center = true,
  size = { "monitor_w * 0.7", "monitor_h * 0.7" },
})

hl.window_rule({
  match = { class = "(code|nemo|org.gnome.Nautilus|org.kde.dolphin)" },
  opacity = "0.9 override 0.9 override",
})

hl.window_rule({
  match = {
    title = "^(Footprint Chooser.*)",
    class = "kicad",
    float = true,
  },
  size = { 1411, 854 },
  center = true,
})
