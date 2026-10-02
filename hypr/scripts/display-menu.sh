#!/usr/bin/env bash
set -uo pipefail

report_error() {
  printf '%s\n' "$1" >&2
  if command -v notify-send >/dev/null 2>&1; then
    notify-send -u critical "Display" "$1" || true
  fi
}

monitor_connected() {
  hyprctl -j monitors all | jq -e --arg name "$1" \
    'any(.[]; .name == $name)' >/dev/null
}

wait_for_monitor() {
  local attempt
  for ((attempt = 0; attempt < 30; attempt++)); do
    if hyprctl -j monitors | jq -e --arg name "$1" \
      'any(.[]; .name == $name and .disabled != true and .dpmsStatus == true and .width > 0 and .height > 0)' >/dev/null; then
      return 0
    fi
    sleep 0.1
  done
  return 1
}

enable_monitor() {
  local output="$1" mode="$2" position="$3" scale="$4"
  # hl.monitor updates the existing rule: omitted disabled stays true.
  hyprctl eval "hl.monitor({ output = \"$output\", disabled = false,
    mode = \"$mode\", position = \"$position\", scale = $scale })" || return 1
  hyprctl dispatch "hl.dsp.dpms({ action = \"enable\", monitor = \"$output\" })" || return 1
  wait_for_monitor "$output"
}

enable_laptop() {
  enable_monitor eDP-1 '2880x1800@120' 0x0 2 ||
    enable_monitor eDP-1 preferred 0x0 2
}

disable_monitor() {
  hyprctl eval "hl.monitor({ output = \"$1\", disabled = true })"
}

if [[ "${1:-}" == "--recover" ]]; then
  # Can be run from a blind keybinding; leave any working external screen on.
  enable_monitor eDP-1 preferred 0x0 2 || {
    report_error "Could not restore the laptop display."
    exit 1
  }
  exit 0
fi

choice=$(
  printf '%s\n' \
    "External only" \
    "Laptop only" \
    "Extend" |
    rofi -dmenu -i -p "Display"
) || exit 0

case "$choice" in
  "External only")
    if ! monitor_connected HDMI-A-1 ||
       ! enable_monitor HDMI-A-1 '1920x1080@100' 0x0 1; then
      if enable_laptop; then
        report_error "External display unavailable; laptop display enabled."
      else
        report_error "Could not activate either display; no display was disabled."
      fi
      exit 1
    fi
    # Never turn off the current screen before its replacement is active.
    disable_monitor eDP-1
    ;;

  "Laptop only")
    if ! enable_laptop; then
      report_error "Laptop display did not become active; external display kept enabled."
      exit 1
    fi
    disable_monitor HDMI-A-1
    ;;

  "Extend")
    if ! enable_laptop; then
      report_error "Could not enable the laptop display; external display kept enabled."
      exit 1
    fi
    if ! monitor_connected HDMI-A-1 ||
       ! enable_monitor HDMI-A-1 '1920x1080@100' 1440x0 1; then
      report_error "External display unavailable; laptop display kept enabled."
      exit 1
    fi
    ;;
esac
