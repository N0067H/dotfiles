# NixOS Dotfiles

Personal NixOS configuration and linked application settings for an ASUS
Zenbook 14. The primary desktop is **Niri + Noctalia**, with the OceanDusk
palette and a night-sea wallpaper. Hyprland, driftwm, and GNOME remain available
as alternate GDM sessions.

- Host / architecture: `nixos` / `x86_64-linux`
- User / locale: `noobth` / English UI, Korean input via Fcitx5
- Nixpkgs: `nixos-26.05`, pinned in `flake.lock`
- Terminal / editor: Kitty / Helix, Ayu Mirage colors

## Setup

```sh
git clone https://github.com/N0067H/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
just link
just theme ocean
just desktop-setup
just check
```

Linking backs up existing targets in `~/.dotfiles-backup/<timestamp>/`.
To link only part of the setup, use `just link desktop`, `just link editors`,
`just link shell`, or an app such as `just link kitty`. Optional machine-local
setup values are documented in `config/local.env.example`.

The theme command requires Noctalia to be running in a graphical session.
On a fresh machine, apply the NixOS configuration first, log into Niri, then
select the theme. Review the hardware file, host username, and display settings
before applying this personal configuration to another machine.

## Common commands

| Command | Action |
| --- | --- |
| `just check` | Validate app links, scripts, theme assets, and Niri config |
| `just check-nix` | Evaluate the NixOS system without activating it |
| `just link [group-or-app]` | Link all or selected application settings |
| `just themes` / `just theme ocean` | List / apply desktop presets |
| `just desktop-setup` | Apply weather, night light, authentication, and idle defaults |
| `sudo nixos-rebuild test --flake .#nixos` | Temporarily activate the system configuration |
| `sudo nixos-rebuild switch --flake .#nixos` | Activate and select it for future boots |
| `just k8s-up` / `just k8s-status` / `just k8s-down` | Manage the local kind cluster |

`Super+D` opens the launcher, `Super+S` the control center, and
`Super+Shift+,` Noctalia settings. `Super+Shift+/` shows Niri's hotkey overlay.

## Where to change things

- [Structure and ownership](docs/structure.md): system modules, sessions, links, local values.
- [Desktop sessions](docs/desktop.md): Niri/Hyprland bindings and display setup.
- [Themes and wallpapers](docs/themes.md): presets, transparency, wallpaper sources.
- [Development tools](docs/development.md): shell aliases and local Kubernetes.
- [Services and app integration](docs/services.md): PostgreSQL, VPNs, Codex flags.

System installation is managed by the flake and `nixos/`; editable app settings
stay in their named root directories. `setup.sh` links them into the home
folder. Runtime data, credentials, caches, and local environment overrides
are kept outside version control.
