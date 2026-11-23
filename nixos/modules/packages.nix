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
    openbao

    pince
    (writeShellScriptBin "pince-gui" ''
      exec /run/wrappers/bin/pkexec ${coreutils}/bin/env \
        DISPLAY="$DISPLAY" \
        XAUTHORITY="$XAUTHORITY" \
        WAYLAND_DISPLAY="$WAYLAND_DISPLAY" \
        XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" \
        ${pince}/bin/pince "$@"
    '')
    (lib.hiPrio (makeDesktopItem {
      name = "PINCE";
      desktopName = "PINCE";
      comment = "Reverse engineering tool and memory scanner";
      exec = "pince-gui";
      icon = "utilities-system-monitor";
      categories = [ "Development" ];
    }))

    # SNS
    discord-ptb
    element-desktop
    (pkgs.callPackage ../packages/picora.nix { })

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
    apostrophe
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

  boot.kernel.sysctl."kernel.yama.ptrace_scope" = 0;
}
