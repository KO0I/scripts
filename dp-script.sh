#!/bin/bash

if [[ $(< /sys/class/drm/card0-DP-1/status) = "connected" ]]; then
  xrandr --output HDMI-2 --off --output HDMI-1 --off --output DP-1 --mode 1920x1200 --pos 0x0 --rotate normal --output eDP-1 --off --output DP-2 --off
#nitrogen ~/Pictures/nat
else
  xrandr --output HDMI-2 --off --output HDMI-1 --off --output DP-1 --off --output eDP-1 --mode 1366x768 --pos 0x0 --rotate normal --output eDP-1 --off --output DP-2 --off
fi
nitrogen --restore &
