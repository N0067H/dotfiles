{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.variables.PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";

  environment.systemPackages = with pkgs; [
    # Dev
    nodejs
    python3
    python3Packages.pip
    pipx
    vscode
    rustup
    go
    git
    gh
    gcc
    cmake
    llvm
    clang
    clang-tools
    pkg-config
    postgresql_16
    protobuf
    ruby
    just
    helix
    llvmPackages.lldb
    qemu
    k6
    teleport
    awscli2

    # SNS
    discord-ptb
    element-desktop

    # Play
    spotify

    # Notifications
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

    # Shared Wayland utilities (session-specific tools live in sessions/)
    kitty
    waybar
    rofi
    mouseless

    # Desktop
    pavucontrol
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
    rose-pine-cursor
    openssl
    openssl.dev 
    unzip
  ];
}
