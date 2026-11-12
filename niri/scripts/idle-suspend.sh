#!/usr/bin/env bash
set -euo pipefail

# Online external supplies include AC adapters and USB-C chargers.
for supply in /sys/class/power_supply/*; do
  [[ -r "$supply/type" && -r "$supply/online" ]] || continue
  [[ "$(<"$supply/type")" != Battery ]] || continue
  if [[ "$(<"$supply/online")" == 1 ]]; then
    exit 0
  fi
done

# Noctalia applies its lock-before-suspend setting to this session action.
exec noctalia msg session suspend
