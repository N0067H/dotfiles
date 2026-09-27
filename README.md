# NixOS Dotfiles

Personal NixOS and Hyprland configuration for my ASUS Zenbook 14.

This repository is the source of truth for my NixOS system configuration and desktop dotfiles. The system configuration is managed with a Nix flake, while application configs are linked directly from this repository.

## System

- **OS:** NixOS
- **Desktop:** Hyprland
- **Display Manager:** GDM
- **Shell:** Zsh
- **Terminal:** Kitty
- **Prompt:** Starship
- **Launcher:** Rofi
- **Bar:** Waybar
- **Notifications:** SwayNotificationCenter
- **File Manager:** Nautilus
- **Browser:** Firefox
- **Theme:** Ayu Mirage
- **Font:** JetBrainsMono Nerd Font

### Hardware

- **Laptop:** ASUS Zenbook 14 UX3405MA
- **CPU:** Intel Core Ultra 9 185H
- **GPU:** Intel integrated graphics
- **Memory:** 32 GB
- **Display:** 2880×1800 OLED, 120 Hz
- **Storage:** 1 TB NVMe SSD
- **Boot:** Windows 11 / NixOS dual boot

## Repository Structure

```text
.
├── flake.nix
├── flake.lock
│
├── nixos/
│   ├── configuration.nix
│   └── hardware-configuration.nix
│
├── hypr/
├── waybar/
├── rofi/
├── kitty/
├── zsh/
├── starship/
├── swaync/
├── gtk-3.0/
├── gtk-4.0/
├── firefox/
└── codex-desktop/
```

### NixOS

`flake.nix` is the entry point for the system configuration.

The current host is:

```text
nixos
```

The main system configuration lives in:

```text
nixos/configuration.nix
```

Hardware-specific configuration lives in:

```text
nixos/hardware-configuration.nix
```

## Rebuilding NixOS

Test a configuration without making it the permanent boot configuration:

```bash
sudo nixos-rebuild test --flake ~/dev/dotfiles#nixos
```

Apply the configuration:

```bash
sudo nixos-rebuild switch --flake ~/dev/dotfiles#nixos
```

Zsh aliases are provided for both:

```bash
nrt
nrs
```

Where:

```text
nrt → nixos-rebuild test
nrs → nixos-rebuild switch
```

My usual workflow is:

```bash
nrt
nrs
```

Test first, then switch once the configuration works.

## Dotfile Management

Application configuration files are stored in this repository and linked into `~/.config`.

Examples:

```text
~/.config/hypr    → ~/dev/dotfiles/hypr
~/.config/waybar  → ~/dev/dotfiles/waybar
~/.config/rofi    → ~/dev/dotfiles/rofi
~/.config/kitty   → ~/dev/dotfiles/kitty
~/.config/swaync  → ~/dev/dotfiles/swaync
~/.config/gtk-3.0 → ~/dev/dotfiles/gtk-3.0
~/.config/gtk-4.0 → ~/dev/dotfiles/gtk-4.0
~/.zshrc          → ~/dev/dotfiles/zsh/.zshrc
```

Because these are symlinks, most application configuration changes take effect without rebuilding NixOS.

System-level changes in `nixos/configuration.nix` require a rebuild.

## Shell

Zsh is configured with:

- Starship
- zoxide
- fzf
- zsh autosuggestions
- zsh syntax highlighting
- eza
- bat
- ripgrep

Useful aliases include:

```text
ll      detailed directory listing
la      include hidden files
tree    directory tree
ff      fastfetch

gs      git status
gd      git diff
ga      git add
gc      git commit
gp      git push
gl      git log

nrt     test NixOS configuration
nrs     switch NixOS configuration
dots    cd ~/dev/dotfiles
```

## CLI Tools

The system also includes several modern CLI utilities:

| Tool | Purpose |
| --- | --- |
| `eza` | Modern `ls` alternative |
| `bat` | Syntax-highlighted file viewer |
| `ripgrep` | Fast recursive text search |
| `fd` | Fast file search |
| `fzf` | Fuzzy finder |
| `zoxide` | Smarter directory navigation |
| `jq` | JSON processor |
| `yq` | YAML processor |
| `dust` | Disk usage viewer |
| `duf` | Filesystem usage viewer |
| `procs` | Modern process viewer |
| `tldr` | Practical command examples |
| `btop` | System resource monitor |
| `fastfetch` | System information |

## Hyprland

Hyprland is the primary Wayland compositor.

The configuration includes:

- Workspace navigation
- Window movement
- Mouse window dragging/resizing
- Special workspace
- Rofi launcher
- Hyprlock
- Clipboard history with `cliphist`
- Waybar
- SwayNotificationCenter
- Hypridle
- Korean input through Fcitx5
- Touchpad configuration
- Ayu Mirage colors

Some useful keybindings:

| Key | Action |
| --- | --- |
| `Super + T` | Open terminal |
| `Super + C` | Close window |
| `Super + E` | Open file manager |
| `Super + R` | Open Rofi |
| `Super + B` | Open Firefox |
| `Super + L` | Lock screen |
| `Alt + Tab` | Cycle windows |
| `Super + 1..0` | Switch workspace |
| `Super + Shift + 1..0` | Move window to workspace |
| `Super + Shift + V` | Clipboard history |

## Kitty

Kitty uses JetBrainsMono Nerd Font and an Ayu Mirage-inspired color scheme.

The configuration includes:

- Native Wayland rendering
- Custom cursor
- Scrollback
- Shell integration
- Tab management
- Current-directory-aware new tabs
- Nerd Font icons
- Ayu Mirage colors

## Korean Input

Korean input is provided by Fcitx5 with `fcitx5-hangul`.

The NixOS configuration manages the input method declaratively.

## Codex Desktop

Codex Desktop is installed through the Nix flake.

Native Wayland rendering is enabled through:

```text
codex-desktop/electron-flags.conf
```

with:

```text
--ozone-platform=wayland
```

Only the persistent configuration is stored in this repository.

Runtime data such as cookies, sessions, caches, credentials, and local storage should remain outside the repository.

## Fresh Installation

This repository is primarily intended for my own machine and contains hardware- and user-specific configuration.

Do **not** blindly apply it to another machine.

For my current system, clone the repository:

```bash
mkdir -p ~/dev
git clone git@github.com:N0067H/dotfiles.git ~/dev/dotfiles
cd ~/dev/dotfiles
```

The repository contains the NixOS hardware configuration used by this machine.

Before rebuilding, review at least:

```text
flake.nix
nixos/configuration.nix
nixos/hardware-configuration.nix
```

Then test the configuration:

```bash
sudo nixos-rebuild test --flake .#nixos
```

If successful:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

Application configs can then be linked into the home directory as needed.

Example:

```bash
ln -s ~/dev/dotfiles/hypr ~/.config/hypr
ln -s ~/dev/dotfiles/waybar ~/.config/waybar
ln -s ~/dev/dotfiles/rofi ~/.config/rofi
ln -s ~/dev/dotfiles/kitty ~/.config/kitty
ln -s ~/dev/dotfiles/swaync ~/.config/swaync

ln -s ~/dev/dotfiles/zsh/.zshrc ~/.zshrc
```

Existing files should be backed up or removed before creating these symlinks.

## Git Workflow

After changing system configuration:

```bash
nrt
```

If the test succeeds:

```bash
nrs
```

Then review and commit:

```bash
git status
git diff
git add -A
git commit
git push
```

## Notes

This is a personal configuration rather than a general-purpose NixOS distribution or installer.

Some values are intentionally specific to:

- the `noobth` user
- the `nixos` hostname
- ASUS Zenbook hardware
- my directory layout
- my preferred applications and keybindings

Review the configuration before reusing it on another system.

