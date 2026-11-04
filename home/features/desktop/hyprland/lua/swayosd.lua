local mod = "SUPER"

-- Normal swayosd control for brightnessc, volume and locks
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise 5%+"), {locked=true})
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness raise 5%-"), {locked=true})
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume +5 --max-volume=100"), {locked=true}  )
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -5"), {locked=true})
hl.bind("Caps_Lock", hl.dsp.exec_cmd("swayosd-client --caps-lock"), {release=true})
hl.bind("Scroll_Lock", hl.dsp.exec_cmd("swayosd-client --scroll-lock"), {release=true})
hl.bind("Num_Lock", hl.dsp.exec_cmd("swayosd-client --num-lock"), {release=true})

hl.bind(mod .. " + XF86MonBrightnessUp", hl.dsp.exec_cmd("ddcutil --bus 11 setvcp 10 + 5"), {locked=true})
hl.bind(mod .. " + XF86MonBrightnessDown", hl.dsp.exec_cmd("ddcutil --bus 11 setvcp 10 - 5"), {locked=true})
