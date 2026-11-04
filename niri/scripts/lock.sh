#!/usr/bin/env bash
set -euo pipefail
repo="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
wallpaper="$(timeout 2 noctalia msg wallpaper-get 2>/dev/null || true)"
if [[ ! -f "$wallpaper" ]]; then
  wallpaper="$repo/$(jq -r '.wallpaper' "$repo/themes/ocean/preset.json")"
fi
args=(--config "$repo/swaylock/config")
if [[ -f "$wallpaper" ]]; then args+=(--image "$wallpaper"); fi
exec swaylock "${args[@]}"
