#!/usr/bin/env bash
set -euo pipefail

laptop=eDP-1
external=HDMI-A-1

report_error() {
  printf '%s\n' "$1" >&2
  notify-send -u critical "Display" "$1" || true
}

connected() {
  niri msg -j outputs | jq -e --arg name "$1" 'has($name)' >/dev/null
}

ready() {
  niri msg -j outputs | jq -e --arg name "$1" '.[$name].logical != null' >/dev/null
}

wait_ready() {
  local attempt
  for ((attempt = 0; attempt < 30; attempt++)); do
    if ready "$1"; then
      return 0
    fi
    sleep 0.1
  done
  return 1
}

enable_output() {
  local output="$1" width="$2" height="$3" scale="$4" x="$5"
  connected "$output" || return 1
  niri msg output "$output" on || return 1
  # Without a refresh value, niri picks the highest rate for this resolution.
  niri msg output "$output" mode "${width}x${height}" || niri msg output "$output" mode auto
  niri msg output "$output" scale "$scale"
  niri msg output "$output" position set "$x" 0
  wait_ready "$output"
}

enable_laptop() {
  enable_output "$laptop" 2880 1800 2 0
}

if [[ "${1:-}" == "--recover" ]]; then
  enable_laptop || {
    report_error "Could not restore the laptop display."
    exit 1
  }
  exit 0
fi

choice="$(printf '%s\n' 'External only' 'Laptop only' 'Extend' | rofi -dmenu -i -p Display)" || exit 0

case "$choice" in
  'External only')
    if ! enable_output "$external" 1920 1080 1 0; then
      enable_laptop || true
      report_error "External display unavailable; laptop display kept on."
      exit 1
    fi
    niri msg output "$laptop" off
    ;;
  'Laptop only')
    if ! enable_laptop; then
      report_error "Laptop display unavailable; external display kept on."
      exit 1
    fi
    if connected "$external"; then
      niri msg output "$external" off
    fi
    ;;
  'Extend')
    if ! enable_laptop; then
      report_error "Laptop display unavailable; external display kept on."
      exit 1
    fi
    if ! enable_output "$external" 1920 1080 1 1440; then
      report_error "External display unavailable; laptop display kept on."
      exit 1
    fi
    ;;
esac
