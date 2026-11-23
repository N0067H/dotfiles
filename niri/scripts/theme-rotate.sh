#!/usr/bin/env bash
set -euo pipefail
repo="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
: "${XDG_RUNTIME_DIR:?A running desktop session is required}"
: "${NIRI_SOCKET:?A running Niri session is required}"
# Only one observer per session, including when started manually.
session="$(printf '%s' "$NIRI_SOCKET" | sha256sum | cut -d ' ' -f 1)"
exec 8>"$XDG_RUNTIME_DIR/dotfiles-theme-rotate-$session.lock"
flock -n 8 || exit 0
marker="$XDG_RUNTIME_DIR/dotfiles-theme-started-$session"
previous=unknown
pending=false
while [[ -S "$NIRI_SOCKET" ]]; do
  # Failed IPC must never be mistaken for an unlock.
  if status="$(timeout 3 noctalia msg status 2>/dev/null)" &&
     locked="$(jq -er '.locked | if type == "boolean" then tostring else error("missing lock state") end' <<< "$status" 2>/dev/null)"; then
    if [[ "$locked" == false ]]; then
      if [[ "$previous" == true || ! -f "$marker" ]]; then pending=true; fi
      if [[ "$pending" == true ]]; then
        if bash "$repo/scripts/theme.sh" --next; then
          touch "$marker"
          pending=false
        else
          echo 'Theme rotation failed; retrying after the next status check.' >&2
        fi
      fi
    fi
    previous="$locked"
  fi
  sleep 2
done
