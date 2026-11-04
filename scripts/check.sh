#!/usr/bin/env bash
set -euo pipefail
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo"
while IFS= read -r -d '' script; do
  bash -n "$script"
done < <(find scripts hypr/scripts niri/scripts bin -type f \( -name '*.sh' -o -name codex \) -print0)
bash -n setup.sh
while IFS= read -r -d '' script; do ruby -c "$script"; done < <(find scripts -name '*.rb' -print0)
for preset in themes/*/preset.json; do
  jq -e '.palette and .mode and .wallpaper' "$preset" > /dev/null
  [[ -f "$(jq -r '.wallpaper' "$preset")" ]]
  jq -e '.dark.terminal and .dark.primary' "noctalia/palettes/$(jq -r '.palette' "$preset").json" > /dev/null
  niri validate -c "$(dirname "$preset")/niri.kdl"
done
niri validate -c "$repo/niri/config.kdl"
bash setup.sh --check
git diff --check
echo 'All local checks passed. Run just check-nix for full system evaluation.'
