{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Dev
    vscode
    rustup
    git
    gcc
    pkg-config

    # SNS
    discord-ptb
    element-desktop

    # Play
    spotify

    # Notifications
    swaynotificationcenter
    libnotify

    # Utilities
    vim
    wget
    setxkbmap
    wl-clipboard
    cliphist
    slurp
    grim
    delta

    # Hyprland
    kitty
    waybar
    rofi
    hyprpaper
    hyprlock
    hypridle
    hyprshot

    # Desktop
    pavucontrol
    networkmanagerapplet
    blueman
    nautilus
    brightnessctl
    nerd-fonts.jetbrains-mono

    # Shell / CLI
    starship
    zsh
    zsh-fzf-tab
    zoxide
    fzf
    eza
    bat
    btop
    fastfetch
    ripgrep
    fd
    jq
    yq-go
    dust
    duf
    procs
    tldr

    # Util
    rose-pine-hyprcursor 
    openssl
    openssl.dev 
  ];
}
