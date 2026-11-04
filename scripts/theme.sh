#!/usr/bin/env bash
set -euo pipefail
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
name="${1:-ocean}"
if [[ "$name" == --list ]]; then
  for preset in "$repo"/themes/*/preset.json; do
    basename "$(dirname "$preset")"
  done
  exit 0
fi
[[ "$name" =~ ^[a-z0-9_-]+$ ]] || { echo 'Invalid theme name' >&2; exit 1; }
preset="$repo/themes/$name/preset.json"
[[ -f "$preset" ]] || { echo "Unknown theme: $name" >&2; exit 1; }
palette="$(jq -er '.palette' "$preset")"
mode="$(jq -er '.mode' "$preset")"
wallpaper="$repo/$(jq -er '.wallpaper' "$preset")"
[[ -f "$wallpaper" && -f "$repo/noctalia/palettes/$palette.json" && -f "$repo/themes/$name/niri.kdl" ]]
# Validate the preset before changing the active compositor configuration.
niri validate -c "$repo/themes/$name/niri.kdl"
bash "$repo/setup.sh" --link noctalia
noctalia msg color-scheme-set custom "$palette"
noctalia msg theme-mode-set "$mode"
noctalia msg wallpaper-set "$wallpaper"
ln -sfn "../themes/$name/niri.kdl" "$repo/niri/theme.kdl"
printf 'Applied theme: %s\n' "$name"
