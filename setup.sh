#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

declare -a LINKS=(
  "hypr:$HOME/.config/hypr"
  "waybar:$HOME/.config/waybar"
  "rofi:$HOME/.config/rofi"
  "kitty:$HOME/.config/kitty"
  "swaync:$HOME/.config/swaync"
  "gtk-3.0:$HOME/.config/gtk-3.0"
  "gtk-4.0:$HOME/.config/gtk-4.0"
  "starship/starship.toml:$HOME/.config/starship.toml"
  "zsh/.zshrc:$HOME/.zshrc"
  "firefox/chrome:$HOME/.config/mozilla/firefox/5qu4wikv.default/chrome"
)

backup_target() {
  local target="$1"

  [[ -e "$target" || -L "$target" ]] || return 0

  # 이미 올바른 symlink면 아무것도 안 함
  if [[ -L "$target" ]]; then
    local current
    current="$(readlink -f "$target" 2>/dev/null || true)"

    if [[ "$current" == "$DOTFILES"* ]]; then
      echo "  OK     $target"
      return 1
    fi
  fi

  mkdir -p "$BACKUP"

  local relative="${target#$HOME/}"
  local destination="$BACKUP/$relative"

  mkdir -p "$(dirname "$destination")"

  echo "  BACKUP $target"
  mv "$target" "$destination"
}

link_one() {
  local source="$DOTFILES/$1"
  local target="$2"

  if [[ ! -e "$source" ]]; then
    echo "  SKIP   $source (not found)"
    return
  fi

  if ! backup_target "$target"; then
    return
  fi

  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"

  echo "  LINK   $target -> $source"
}

check_one() {
  local source="$DOTFILES/$1"
  local target="$2"

  if [[ ! -e "$source" ]]; then
    printf "SKIP  %-45s source missing\n" "$target"
  elif [[ -L "$target" ]] && [[ "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
    printf "OK    %s\n" "$target"
  elif [[ -e "$target" || -L "$target" ]]; then
    printf "WARN  %-45s not linked to repo\n" "$target"
  else
    printf "MISS  %s\n" "$target"
  fi
}

link_codex() {
  local source="$DOTFILES/codex-desktop/electron-flags.conf"
  local target="$HOME/.config/codex-desktop/electron-flags.conf"

  [[ -f "$source" ]] || {
    echo "  SKIP   Codex Desktop flags (not found)"
    return
  }

  # Codex runtime 디렉터리 전체는 절대 symlink하지 않음
  mkdir -p "$HOME/.config/codex-desktop"

  if ! backup_target "$target"; then
    return
  fi

  ln -s "$source" "$target"
  echo "  LINK   $target -> $source"
}

check_codex() {
  local source="$DOTFILES/codex-desktop/electron-flags.conf"
  local target="$HOME/.config/codex-desktop/electron-flags.conf"

  [[ -f "$source" ]] || return

  if [[ -L "$target" ]] && [[ "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
    echo "OK    $target"
  else
    echo "WARN  $target"
  fi
}

case "${1:---link}" in
  --link)
    echo "Linking dotfiles from:"
    echo "  $DOTFILES"
    echo

    for entry in "${LINKS[@]}"; do
      source="${entry%%:*}"
      target="${entry#*:}"
      link_one "$source" "$target"
    done

    link_codex

    echo
    echo "Done."

    if [[ -d "$BACKUP" ]]; then
      echo "Previous files backed up to:"
      echo "  $BACKUP"
    fi
    ;;

  --check)
    echo "Checking dotfiles..."
    echo

    for entry in "${LINKS[@]}"; do
      source="${entry%%:*}"
      target="${entry#*:}"
      check_one "$source" "$target"
    done

    check_codex
    ;;

  *)
    echo "Usage:"
    echo "  ./setup.sh --link"
    echo "  ./setup.sh --check"
    exit 1
    ;;
esac
