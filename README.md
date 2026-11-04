# NixOS Dotfiles

Personal NixOS configuration and desktop dotfiles for an ASUS Zenbook 14.
System configuration is managed with a Nix flake; application settings are
linked from this repository with [`setup.sh`](setup.sh).

The configuration enables **Niri, Hyprland, GNOME, and an experimental driftwm
session** through GDM. Each compositor has its own configuration; Waybar,
Rofi, Kitty, and notification styles are shared where referenced.

Niri uses Noctalia 5.4.1 for its bar, launcher, and notifications. `Super+D`
opens the launcher, `Super+S` opens the control center, and `Super+Shift+,`
opens settings. The Noctalia release is pinned in `flake.nix` and `flake.lock`.
The OceanDusk palette lives in `noctalia/palettes/`; `setup.sh` links it into
Noctalia's config directory. After linking, select the current desktop look with:

```sh
noctalia msg color-scheme-set custom OceanDusk
noctalia msg theme-mode-set dark
noctalia msg wallpaper-set "$HOME/dev/dotfiles/wallpapers/ocean-blue-hour-soft-lift.png"
```

Niri uses matching blue/teal borders with 12px rounded and clipped corners.
Generated wallpaper variants and the original Ferris asset sources are kept in
`wallpapers/`; Ferris town SVGs can be regenerated with the Ruby scripts there.

## System

| Component | Configuration |
| --- | --- |
| Nixpkgs input | `nixos-26.05`, revisions pinned in `flake.lock` |
| Architecture / host | `x86_64-linux` / `nixos` |
| User / timezone | `noobth` / `Asia/Seoul` |
| Display manager | GDM |
| Desktop sessions | Niri, Hyprland, GNOME, driftwm |
| Terminal / shell / prompt | Kitty / Zsh / Starship |
| Launcher / bar / notifications | Rofi / Waybar / SwayNotificationCenter |
| Browser / file manager | Firefox / Nautilus |
| Audio / networking | PipeWire / NetworkManager |
| Korean input | Fcitx5 with `fcitx5-hangul` |
| Colors / font | Ayu Mirage-inspired / JetBrainsMono Nerd Font |

The target laptop is an ASUS Zenbook 14 UX3405MA with an Intel Core Ultra 9
185H, integrated graphics, 32 GB RAM, a 2880×1800 OLED display at 120 Hz,
and a 1 TB NVMe SSD. The machine dual-boots Windows 11 and NixOS.

This is a personal configuration. Before applying it elsewhere, adapt the
hardware configuration, username, hostname, display outputs, and paths.
Several desktop files reference `/home/noobth/dev/dotfiles` directly.

## Configuration map

| Location | Purpose |
| --- | --- |
| [`flake.nix`](flake.nix), [`flake.lock`](flake.lock) | System entry point and pinned inputs; Codex Desktop and driftwm inputs |
| [`nixos/configuration.nix`](nixos/configuration.nix) | Host configuration, module imports, user, networking, and services |
| [`nixos/hardware-configuration.nix`](nixos/hardware-configuration.nix) | Machine-specific hardware and filesystem configuration |
| [`nixos/modules/desktop.nix`](nixos/modules/desktop.nix) | Desktop sessions, audio, input method, and font rendering |
| [`nixos/modules/packages.nix`](nixos/modules/packages.nix) | Desktop applications, development tools, and CLI utilities |
| [`nixos/modules/shell.nix`](nixos/modules/shell.nix) | Zsh and the user's login shell |
| [`nixos/modules/docker.nix`](nixos/modules/docker.nix) | Docker daemon and user group |
| [`nixos/modules/kubernetes.nix`](nixos/modules/kubernetes.nix) | Kubernetes development tools |
| [`niri/`](niri) | Niri config, its Waybar modules, and display menu |
| [`hypr/`](hypr) | Hyprland Lua config, modules, wallpaper, lock, idle, and scripts |
| [`driftwm/`](driftwm) | Experimental driftwm config and its Waybar modules |
| [`waybar/`](waybar), [`rofi/`](rofi), [`swaync/`](swaync) | Bar, launcher, and notification configuration |
| [`kitty/`](kitty), [`gtk-3.0/`](gtk-3.0), [`gtk-4.0/`](gtk-4.0) | Terminal and GTK appearance |
| [`helix/`](helix), [`vscode/`](vscode), [`firefox/`](firefox) | Editor settings and Firefox browser chrome |
| [`zsh/`](zsh), [`starship/`](starship) | Shell configuration and prompt |
| [`autostart/`](autostart), [`bin/`](bin), [`codex-desktop/`](codex-desktop) | Session autostart, user commands, and application flags |
| [`kubernetes/kind.yaml`](kubernetes/kind.yaml), [`justfile`](justfile) | Local Kubernetes cluster and commands |

Some system options and packages are also declared directly in
`nixos/configuration.nix`; consult it together with the imported modules.

## Setup and rebuild

Clone to the path used by the current desktop configuration:

```bash
mkdir -p ~/dev
git clone https://github.com/N0067H/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
```

For another machine, review `flake.nix`, `nixos/configuration.nix`, the imported
modules, and `nixos/hardware-configuration.nix` before rebuilding. The shell
and Docker modules also refer to the `noobth` user.

Test the system configuration, then persist it once it works:

```bash
sudo nixos-rebuild test --flake .#nixos
sudo nixos-rebuild switch --flake .#nixos
```

Link application settings and inspect the links:

```bash
./setup.sh --link
./setup.sh --check
```

`--link` moves existing targets into `~/.dotfiles-backup/<timestamp>/` before
creating symlinks. It links all configured applications, including editor
settings, the Fcitx autostart entry, and `~/.local/bin/codex`; it does not
install packages or rebuild NixOS. `--check` reports link status without
changing files. Run `--check` again after linking to inspect the results.

The Firefox chrome target in `setup.sh` contains the personal profile name
`5qu4wikv.default`; change it for another profile. The Zsh `code` alias points
to `~/.local/share/vscode-vibrancy/current/bin/code`, which must exist separately.

For selective reuse, link only the directories you need after backing up any
existing targets. Configuration edits may require an application reload or
session restart. Changes to NixOS modules or flake inputs require a rebuild.

## Niri

### Files and installation

- [`niri/config.kdl`](niri/config.kdl): input, layout, borders, startup commands, and keybindings.
- [`niri/waybar.jsonc`](niri/waybar.jsonc): Niri workspace module and bar widgets.
- [`niri/scripts/display-menu.sh`](niri/scripts/display-menu.sh): laptop/external display switching and recovery.
- [`waybar/style.css`](waybar/style.css): shared bar style used by Niri.

The NixOS session is enabled in `nixos/modules/desktop.nix` with:

```nix
programs.niri.enable = true;
```

To reuse just Niri, enable that option in your own NixOS configuration and
install the applications referenced by the settings. The current setup uses
Kitty, Firefox, Rofi, Nautilus, Waybar, SwayNotificationCenter, `nm-applet`,
`swaybg`, `swaylock`, Fcitx5, `wl-clipboard`, `cliphist`, `jq`, `libnotify`,
`brightnessctl`, and `wpctl` for audio. Bar click actions also use
`nm-connection-editor` and `pavucontrol`. See
[`nixos/modules/packages.nix`](nixos/modules/packages.nix) for package names and
[`nixos/modules/desktop.nix`](nixos/modules/desktop.nix) for Korean input setup.

Place the Niri directory at `~/.config/niri`, or link it from your checkout.
Adjust the absolute paths to the Waybar config/style, wallpaper, and display
script in `config.kdl`. Copy the shared application configs if you want the
same appearance. The default `setup.sh --link` links these together.

Validate a configuration before using it:

```bash
niri validate -c ~/.config/niri/config.kdl
```

Niri starts Fcitx5 after a short delay. The shared Fcitx autostart entry excludes
Niri so that it uses the startup command in `config.kdl` instead.

### Keybindings

`Super` is the main modifier. Columns scroll horizontally; workspaces extend
vertically, with an empty workspace below the last one.

| Key | Action |
| --- | --- |
| `Super + Shift + /` | Show hotkey overlay |
| `Super + T` / `B` / `D` / `E` | Kitty / Firefox / Rofi / Nautilus |
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

Hyprland uses [`hypr/hyprland.lua`](hypr/hyprland.lua), which loads
[`hypr/modules/autostart.lua`](hypr/modules/autostart.lua) and
[`hypr/modules/appearance.lua`](hypr/modules/appearance.lua). The Lua file is
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
[`driftwm/config.toml`](driftwm/config.toml), with a separate
[`driftwm/waybar.jsonc`](driftwm/waybar.jsonc). It also contains personal wallpaper
paths and display settings. Unspecified options retain driftwm defaults.
GNOME remains enabled as another GDM session.

## Themes and transparency

| Setting | File / location |
| --- | --- |
| Niri border gradient, gaps, cursor | [`niri/config.kdl`](niri/config.kdl): `layout`, `cursor`, and `window-rule` |
| Hyprland opacity, borders, blur | [`hypr/hyprland.lua`](hypr/hyprland.lua), with appearance overrides in [`hypr/modules/appearance.lua`](hypr/modules/appearance.lua) |
| Kitty colors and transparency | [`kitty/kitty.conf`](kitty/kitty.conf): `background_opacity 0.60` |
| Waybar colors and transparency | [`waybar/style.css`](waybar/style.css): `window#waybar`, background alpha `0.34` |
| Rofi colors and layout | [`rofi/theme.rasi`](rofi/theme.rasi), loaded by [`rofi/config.rasi`](rofi/config.rasi) |
| Notification style | [`swaync/style.css`](swaync/style.css) |
| GTK style | [`gtk-3.0/gtk.css`](gtk-3.0/gtk.css), [`gtk-4.0/gtk.css`](gtk-4.0/gtk.css) |
| Wallpaper | Startup commands in Niri/driftwm and [`hypr/hyprpaper.conf`](hypr/hyprpaper.conf) |

Niri does not currently set global window opacity. Kitty and Waybar control
their own transparency; Niri's Kitty rule avoids drawing a border background
behind the translucent terminal. Hyprland additionally applies a Kitty opacity
rule, so its resulting appearance differs from Niri.

Helix uses [`helix/config.toml`](helix/config.toml) and the custom
[`ayu_mirage_bright.toml`](helix/themes/ayu_mirage_bright.toml) theme. Reload an
open session with `:config-reload`. VS Code settings are in
[`vscode/settings.json`](vscode/settings.json); the configured **Ayu Mirage
Bordered** theme requires the `teabyii.ayu` extension. Application extensions,
Helix runtime data, and local transparency tooling are not installed by the
symlink script.

## Shell and development tools

Zsh uses Starship, zoxide, fzf integration, autosuggestions, and syntax
highlighting. CLI tools and language toolchains are listed in
`nixos/modules/packages.nix`.

| Alias | Command / purpose |
| --- | --- |
| `ll` / `la` / `tree` | eza listings and tree view |
| `ff` | fastfetch |
| `gs` / `gd` / `ga` / `gc` / `gp` / `gl` | Git status / diff / add / commit / push / log |
| `nrt` / `nrs` | Test / switch `~/dev/dotfiles#nixos` |
| `dots` | Change to `~/dev/dotfiles` |
| `k` / `kctx` / `kns` | kubectl / kubectx / kubens |

### Local Kubernetes

The Kubernetes module installs kubectl, Helm, kind, k9s, kubectx/kubens,
Kustomize, Skaffold, Stern, and kubeconform. Docker starts on boot; the kind
cluster is created explicitly. After applying Docker group membership, log
out and back in before using it.

```bash
cd ~/dev/dotfiles
just k8s-up
just k8s-status
just k8s-ui
```

[`kubernetes/kind.yaml`](kubernetes/kind.yaml) defines a single control-plane
node with a digest-pinned `kindest/node:v1.35.0` image and a localhost API.
The cluster name is `dev`, and the kubectl context is `kind-dev`.

```bash
docker build -t my-app:dev /path/to/app
just k8s-load my-app:dev
kubectl --context kind-dev apply -f /path/to/app/k8s/
kubectl --context kind-dev port-forward service/my-app 8080:80
stern --context kind-dev my-app
```

Use `image: my-app:dev` and `imagePullPolicy: IfNotPresent` for locally loaded
images. `just k8s-down` deletes the cluster and its workloads/data. Credentials
remain in the local kubeconfig, outside this repository.

## Other services and application integration

The host also enables PostgreSQL 16 (with `mydatabase`), Tailscale, Cloudflare
WARP, Bluetooth/Blueman, printing, Flatpak, and an 80% battery charge threshold
when the machine exposes the configured `BAT0` control file. Review these in
`nixos/configuration.nix` and `nixos/modules/desktop.nix` when reusing the setup.

Codex Desktop is installed from a flake input. The setup script links only its
`electron-flags.conf` for Wayland rendering. The `bin/codex` wrapper uses a
locally installed executable under `~/.codex/packages/app-server-daemon/releases`;
it requires that executable to already exist. Application runtime data,
sessions, credentials, caches, and local storage remain outside this repository.

For WARP, after applying the system configuration:

```bash
warp-cli registration new
warp-cli connect
warp-cli status
```

Accept the registration terms if prompted. Use `warp-cli disconnect` to
disconnect. Registration data lives outside the repository in
`/var/lib/cloudflare-warp`.
