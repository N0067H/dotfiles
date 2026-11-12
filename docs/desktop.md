## Niri

### Files and installation

- [`niri/config.kdl`](../niri/config.kdl): input, layout, borders, startup commands, and keybindings.
- [`niri/waybar.jsonc`](../niri/waybar.jsonc): retained alternate Waybar configuration.
- [`niri/scripts/display-menu.sh`](../niri/scripts/display-menu.sh): laptop/external display switching and recovery.
- [`themes/ocean/niri.kdl`](../themes/ocean/niri.kdl): border colors, included through `niri/theme.kdl`.

The NixOS session is enabled in `nixos/modules/sessions/niri.nix` with:

```nix
programs.niri.enable = true;
```

To reuse just Niri, enable that option in your own NixOS configuration and
install the applications referenced by the settings. The current setup uses
Kitty, Firefox, Noctalia, Rofi (clipboard picker), Nautilus, `swaylock`, Fcitx5,
`wl-clipboard`, `cliphist`, `jq`, `libnotify`, `brightnessctl`, and `wpctl` for
audio. Noctalia supplies the bar, app launcher, notifications, and wallpaper. See
[`nixos/modules/packages.nix`](../nixos/modules/packages.nix) for package names and
[`nixos/modules/desktop.nix`](../nixos/modules/desktop.nix) for Korean input setup.

Place the Niri directory at `~/.config/niri`, or link it from your checkout.
The display menu resolves through `$HOME/.config/niri`. The included theme
resolves relative to the Niri config directory. Use `just link desktop` to link
the configuration and `just theme ocean` to select its palette and wallpaper.

Validate a configuration before using it:

```bash
niri validate -c ~/.config/niri/config.kdl
```

Niri starts Fcitx5 after a short delay. The shared Fcitx autostart entry excludes
Niri so that it uses the startup command in `config.kdl` instead.

`just desktop-setup` applies the service defaults from `noctalia/services.json`:
IP-based location, metric weather, a weather bar widget, the Polkit agent,
night light (6500K day / 4500K night), and idle lock/screen-off/suspend at
10/11/15 minutes. Automatic suspend only runs on battery power; connecting an
AC or USB-C charger keeps the system awake. Lock and screen-off timers still apply.
Location depends on the public IP; a VPN can affect it.
Preferences are persisted by Noctalia. Rerunning the command reapplies these
defaults, including the bar end-widget order. It also selects Ferris as the avatar.

The lock shortcut uses Noctalia's built-in lock, matching the menu and
lock-before-suspend behavior. It authenticates with the system `login` PAM stack.
The existing swaylock configuration remains a fallback when Noctalia is not
running. Fingerprint unlock is disabled until a fingerprint service is configured.
Playback keys use Noctalia's native MPRIS integration; playerctl and cava are
not needed. The active compatible player is selected automatically.

### Keybindings

`Super` is the main modifier. Columns scroll horizontally; workspaces extend
vertically, with an empty workspace below the last one.

| Key | Action |
| --- | --- |
| `Super + Shift + /` | Show hotkey overlay |
| `Super + T` / `B` / `D` / `E` | Kitty / Firefox / Noctalia launcher / Nautilus |
| `Super + S` / `Super + Shift + ,` | Noctalia control center / settings |
| `Super + Q` | Close window |
| `Super + H/J/K/L` | Focus column left / window down / window up / column right |
| `Super + Ctrl + H/J/K/L` | Move column left / window down / window up / column right |
| `Super + ,` / `.` | Stack next window / split window into a new column |
| `Super + [` / `]` | Join or split a window on the left / right |
| `Super + U/I` | Workspace down / up |
| `Super + Ctrl + U/I` | Move column to workspace down / up |
| `Super + R` | Cycle column widths |
| `Super + F` | Maximize column |
| `Super + Shift + F` or `Ctrl + B` | Toggle fullscreen |
| `Super + Space` / `O` | Toggle floating / overview |
| `Super + Shift + V` | Clipboard history |
| `Super + Shift + L` / `E` | Lock / exit session |
| `Super + Shift + P` | Display layout menu |
| `Super + Ctrl + Shift + P` | Restore laptop display |
| `Print` | Screenshot |

The display menu assumes `eDP-1` at 2880×1800 with scale 2 and `HDMI-A-1` at
1920×1080 with scale 1. It offers External only, Laptop only, and Extend.
Edit the output names, resolutions, scales, and positions for your hardware;
`niri msg outputs` lists the available outputs.

## Hyprland and driftwm

Hyprland uses [`hypr/hyprland.lua`](../hypr/hyprland.lua), which loads
[`hypr/modules/autostart.lua`](../hypr/modules/autostart.lua) and
[`hypr/modules/appearance.lua`](../hypr/modules/appearance.lua). The Lua file is
the entry point for the current bindings and window rules; the directory also
contains `.conf` files for individual utilities and monitor/workspace settings.

| Key | Hyprland action |
| --- | --- |
| `Super + T` / `B` / `E` | Kitty / Firefox / Nautilus |
| `Super + R` | Rofi |
| `Super + C` | Close window |
| `Super + L` | Hyprlock |
| `Super + H` | Keybinding help |
| `Super + 1…0` | Switch workspace |
| `Super + Shift + 1…0` | Move window to workspace |
| `Super + Shift + V` | Clipboard history |
| `Super + Shift + P` | Display layout menu |
| `Super + Ctrl + Shift + P` | Restore laptop display |
| `Alt + Tab` | Cycle windows |
| `Print` / `Super + Print` / `Super + Shift + Print` | Region / window / output screenshot |

Hyprland starts Waybar, Hyprpaper, Hypridle, SwayNotificationCenter, and clipboard
watchers. Screenshots are saved to `~/Pictures/Screenshots`.

The experimental driftwm session is enabled through the flake's driftwm module
and `programs.driftwm.enable`. Its settings live in
[`driftwm/config.toml`](../driftwm/config.toml), with a separate
[`driftwm/waybar.jsonc`](../driftwm/waybar.jsonc). It also contains personal wallpaper
paths and display settings. Unspecified options retain driftwm defaults.
GNOME remains enabled as another GDM session.
