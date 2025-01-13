#/usr/bin/env bash

# Composit an x11 window with wayland meant for a single apllication
weston -B x11 --xwayland --shell="kiosk-shell.so"
