#!/usr/bin/env bash

choice=$(
  printf '%s\n' \
    "External only" \
    "Laptop only" \
    "Extend" |
    rofi -dmenu -i -p "Display"
)

case "$choice" in
  "External only")
    hyprctl eval 'hl.monitor({
      output = "HDMI-A-1",
      mode = "1920x1080@100",
      position = "0x0",
      scale = 1
    })'

    sleep 0.3

    hyprctl eval 'hl.monitor({
      output = "eDP-1",
      disabled = true
    })'
    ;;

  "Laptop only")
    hyprctl eval 'hl.monitor({
      output = "eDP-1",
      mode = "2880x1800@120",
      position = "0x0",
      scale = 2
    })'

    sleep 0.3

    hyprctl eval 'hl.monitor({
      output = "HDMI-A-1",
      disabled = true
    })'
    ;;

  "Extend")
    hyprctl eval 'hl.monitor({
      output = "eDP-1",
      mode = "2880x1800@120",
      position = "0x0",
      scale = 2
    })'

    hyprctl eval 'hl.monitor({
      output = "HDMI-A-1",
      mode = "1920x1080@100",
      position = "1440x0",
      scale = 1
    })'
    ;;
esac
