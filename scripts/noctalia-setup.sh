#!/usr/bin/env bash
set -euo pipefail
repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
noctalia msg status >/dev/null
jq -e 'type == "object" and length > 0' "$repo/noctalia/services.json" >/dev/null
while IFS=$'\t' read -r key value; do
  noctalia msg config-set "$key" "$value"
done < <(jq -r 'to_entries[] | [.key, (.value | tojson)] | @tsv' "$repo/noctalia/services.json")
noctalia msg config-set shell.avatar_path "$(jq -cn --arg path "$repo/wallpapers/sources/ferris/ferris-flat.png" '$path')"
echo 'Noctalia services configured. Location uses IP geolocation; weather refreshes every 30 minutes.'
