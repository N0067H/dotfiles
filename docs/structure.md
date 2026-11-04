# Configuration ownership

The flake pins package sources and selects the host modules. Keep each system
option in one module; avoid redeclaring desktop settings in the host file.

| Location | Owns |
| --- | --- |
| `nixos/configuration.nix` | Hardware import, boot, host/user, locale, Nix settings, compatibility version |
| `nixos/hardware-configuration.nix` | Generated hardware/filesystem setup |
| `nixos/modules/desktop.nix` | Shared display manager, input method, audio, Bluetooth, fonts, printing |
| `nixos/modules/sessions/` | Session enablement and session-specific packages |
| `nixos/modules/packages.nix` | Shared desktop apps, development tools, CLI tools |
| `nixos/modules/services.nix` | PostgreSQL, VPN services, battery threshold |
| `nixos/modules/shell.nix` | Zsh system integration and login shell |
| `nixos/modules/docker.nix` | Docker daemon and user group |
| `nixos/modules/kubernetes.nix` | Local Kubernetes tooling |
| App directories at repository root | Editable app configuration linked by `setup.sh` |
| `themes/` and `noctalia/palettes/` | Desktop appearance presets and palettes |
| `scripts/` | Checks, theme application, wallpaper construction |
| `config/local.env` | Optional machine-local setup overrides (gitignored) |

## Sessions

All four remain installed and available in GDM. Modules separate ownership;
they are not runtime toggles for the current login.

| Session | Role | Shell / utilities |
| --- | --- | --- |
| Niri | Primary | Noctalia; Rofi for clipboard history; swaylock |
| Hyprland | Alternate | Waybar, Rofi, SwayNC, Hyprpaper, Hypridle, Hyprlock |
| driftwm | Experimental | Waybar and compositor-managed wallpaper |
| GNOME | Fallback | GNOME Shell |

Waybar and Rofi remain shared installed packages, since multiple sessions use
them. Starting them is the responsibility of the selected session, not a global
autostart entry. Fcitx has a shared autostart entry that excludes Niri; Niri starts
it after a short delay.

## Local values and links

Copy `config/local.env.example` to `config/local.env` to change the Firefox
profile linked by setup. The NixOS username and hardware remain explicit host
configuration. Hyprland and driftwm retain personal wallpaper/display settings;
review these when moving the checkout to another machine.

`setup.sh --link [group-or-app]` creates links and backs up replaced targets in
`~/.dotfiles-backup/<timestamp>/`. `--check` reports missing/incorrect links and
returns a nonzero exit status. Existing links resolving to the source through
a linked parent are preserved, avoiding self-referential links.

Groups are `desktop`, `editors`, `shell`, `browser`, and `tools`; `all` is the
default. App names such as `niri`, `kitty`, `helix`, `noctalia`, or `codex-desktop`
select only that application. `shell` includes Kitty, Zsh, and Starship.
Only Codex Desktop's flags file is managed; no runtime directory link is created.
