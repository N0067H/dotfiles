{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Dev
    nodejs
    vscode
    rustup
    go
    git
    gh
    gcc
    clang
    clang-tools
    pkg-config
    protobuf
    ruby
    just
    helix
    llvmPackages.lldb
    qemu
    k6
    teleport

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
    tailscale
    headscale
    setxkbmap
    wl-clipboard
    cliphist
    slurp
    grim
    delta
    config.boot.kernelPackages.perf
    file

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
    unzip
  ];
}
