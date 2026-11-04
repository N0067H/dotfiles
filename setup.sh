#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
[[ ! -f "$DOTFILES/config/local.env" ]] || source "$DOTFILES/config/local.env"
FIREFOX_PROFILE="${DOTFILES_FIREFOX_PROFILE:-5qu4wikv.default}"
GROUP="${2:-all}"

declare -a LINKS=(
  "hypr:$HOME/.config/hypr"
  "niri:$HOME/.config/niri"
  "noctalia/palettes/OceanDusk.json:$HOME/.config/noctalia/palettes/OceanDusk.json"
  "bin/codex:$HOME/.local/bin/codex"
  "autostart/org.fcitx.Fcitx5.desktop:$HOME/.config/autostart/org.fcitx.Fcitx5.desktop"
  "driftwm:$HOME/.config/driftwm"
  "waybar:$HOME/.config/waybar"
  "rofi:$HOME/.config/rofi"
  "kitty:$HOME/.config/kitty"
  "helix/config.toml:$HOME/.config/helix/config.toml"
  "helix/themes/ayu_mirage_bright.toml:$HOME/.config/helix/themes/ayu_mirage_bright.toml"
  "vscode/settings.json:$HOME/.config/Code/User/settings.json"
  "swaync:$HOME/.config/swaync"
  "swaylock:$HOME/.config/swaylock"
  "gtk-3.0:$HOME/.config/gtk-3.0"
  "gtk-4.0:$HOME/.config/gtk-4.0"
  "starship/starship.toml:$HOME/.config/starship.toml"
  "zsh/.zshrc:$HOME/.zshrc"
  "firefox/chrome:$HOME/.config/mozilla/firefox/$FIREFOX_PROFILE/chrome"
)

selected() {
  local app="${1%%/*}"
  [[ "$GROUP" == all || "$GROUP" == "$app" ]] && return 0
  case "$GROUP:$app" in
    desktop:hypr|desktop:niri|desktop:noctalia|desktop:autostart|desktop:driftwm|desktop:waybar|desktop:rofi|desktop:swaync|desktop:swaylock|desktop:gtk-3.0|desktop:gtk-4.0) return 0 ;;
    editors:helix|editors:vscode|shell:kitty|shell:zsh|shell:starship|browser:firefox|tools:bin|tools:codex-desktop) return 0 ;;
  esac
  return 1
}

valid_group=false
for entry in "${LINKS[@]}" "codex-desktop:"; do
  if selected "${entry%%:*}"; then valid_group=true; break; fi
done
if [[ "$valid_group" != true ]]; then
  echo "Unknown group or app: $GROUP" >&2
  exit 1
fi

backup_target() {
  local target="$1"
  local source="$2"

  [[ -e "$target" || -L "$target" ]] || return 0

  # A parent directory may already be linked: never replace the source with itself.
  if [[ "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
    echo "  OK     $target"
    return 1
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

  if ! backup_target "$target" "$source"; then
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
    printf "FAIL  %-45s source missing\n" "$target"
    return 1
  elif [[ -e "$target" ]] && [[ "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
    printf "OK    %s\n" "$target"
  elif [[ -e "$target" || -L "$target" ]]; then
    printf "WARN  %-45s not linked to repo\n" "$target"
    return 1
  else
    printf "MISS  %s\n" "$target"
    return 1
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

  if ! backup_target "$target" "$source"; then
    return
  fi

  ln -s "$source" "$target"
  echo "  LINK   $target -> $source"
}

check_codex() {
  local source="$DOTFILES/codex-desktop/electron-flags.conf"
  local target="$HOME/.config/codex-desktop/electron-flags.conf"

  [[ -f "$source" ]] || return

  if [[ -e "$target" ]] && [[ "$(readlink -f "$target")" == "$(readlink -f "$source")" ]]; then
    echo "OK    $target"
  else
    echo "WARN  $target"
    return 1
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
      selected "$source" || continue
      link_one "$source" "$target"
    done

    if selected codex-desktop; then link_codex; fi

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

    failed=0
    for entry in "${LINKS[@]}"; do
      source="${entry%%:*}"
      target="${entry#*:}"
      selected "$source" || continue
      check_one "$source" "$target" || failed=1
    done

    if selected codex-desktop; then check_codex || failed=1; fi
    exit "$failed"
    ;;

  *)
    echo "Usage:"
    echo "  ./setup.sh --link [all|desktop|editors|shell|browser|tools|app]"
    echo "  ./setup.sh --check [all|desktop|editors|shell|browser|tools|app]"
    exit 1
    ;;
esac
