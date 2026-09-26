#!/usr/bin/env bash

cat <<'EOF' | rofi -dmenu -i -p '󰌌  Keybindings' -no-custom
━━ Apps ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
󰆍  Super + T                 Terminal
󰈹  Super + B                 Firefox
󰉋  Super + E                 Files
󰍉  Super + R                 App Launcher

━━ Windows ━━━━━━━━━━━━━━━━━━━━━━━━━━
󰆴  Super + C                 Close Window
󰖲  Super + V                 Toggle Floating
󰅖  Alt + Tab                 Next Window
󰁌  Super + ← ↑ ↓ →           Focus Window
󰍽  Super + Left Drag         Move Window
󰩨  Super + Right Drag        Resize Window

━━ Workspaces ━━━━━━━━━━━━━━━━━━━━━━━
󰜎  Super + 1–0               Switch Workspace
󰁯  Super + Shift + 1–0       Move Window
󰖯  Super + Mouse Wheel       Switch Workspace
󰣆  Super + S                 Special Workspace

━━ System ━━━━━━━━━━━━━━━━━━━━━━━━━━━
󰌾  Super + L                 Lock
󰕾  Volume Keys               Volume
󰃠  Brightness Keys           Brightness
󰒲  Super + M                 Exit Hyprland

━━ Clipboard ━━━━━━━━━━━━━━━━━━━━━━━━
󰅇  Super + Shift + V         Clipboard History

━━ Screenshot ━━━━━━━━━━━━━━━━━━━━━━━
󰹑  Print                     Select Region
󰖯  Super + Print             Active Window
󰍹  Super + Shift + Print     Full Output

━━ Help ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
󰋖  Super + H                 This Help
EOF
