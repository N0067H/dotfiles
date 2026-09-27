# Dotfiles

My simple NixOS and Hyprland setup.

## Packages

The following packages are installed by `nixos/configuration.nix`.

| Category | Packages |
| --- | --- |
| Development | VS Code, Rustup, Git, GCC, pkg-config |
| Communication | Discord PTB, Element Desktop |
| Media | Spotify |
| Notifications | SwayNotificationCenter, libnotify |
| Desktop utilities | Vim, Wget, setxkbmap, wl-clipboard, cliphist, slurp, grim, Fastfetch |
| Hyprland desktop | Kitty, Waybar, Rofi, hyprpaper, hyprlock, hypridle, hyprshot |
| System and appearance | pavucontrol, NetworkManager Applet, Blueman, Nautilus, brightnessctl, JetBrainsMono Nerd Font |

Firefox and Hyprland are enabled through NixOS program options. The configuration
also enables GNOME, GDM, PipeWire, NetworkManager, Bluetooth, and the Fcitx5
Hangul and GTK addons.

## Directory structure

| Directory | Role |
| --- | --- |
| `firefox/` | Firefox interface customization in `chrome/userChrome.css` |
| `gtk-3.0/` | GTK 3 styling and Nautilus bookmarks |
| `gtk-4.0/` | GTK 4 styling |
| `hypr/` | Hyprland, hypridle, and hyprlock configuration, split into Lua modules and helper scripts |
| `kitty/` | Kitty terminal configuration |
| `nixos/` | NixOS system configuration and package declarations |
| `rofi/` | Rofi launcher configuration and theme |
| `starship/` | Starship shell prompt configuration |
| `swaync/` | SwayNotificationCenter behavior and styling |
| `waybar/` | Waybar modules, layout, and styling |
| `zsh/` | Zsh shell configuration |

## Install

Clone this repo:

```sh
git clone https://github.com/N0067H/dotfiles.git
cd dotfiles
```

Copy the config you want:

```sh
cp -r hypr waybar rofi kitty swaync starship ~/.config/
cp zsh/.zshrc ~/
```

For NixOS:

```sh
sudo cp nixos/configuration.nix /etc/nixos/
sudo nixos-rebuild switch
```

Check the files before you copy them. Some settings are for my computer.

## Note

The NixOS hardware config is not included. Keep your own
`/etc/nixos/hardware-configuration.nix` file.
