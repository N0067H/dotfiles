{ pkgs, ... }:

{
  imports = [
    ./sessions/niri.nix
    ./sessions/hyprland.nix
    ./sessions/driftwm.nix
    ./sessions/gnome.nix
  ];
  # Package
  services.flatpak.enable = true;
  
  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Display manager / fallback desktop
  services.displayManager.gdm.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing
  services.printing.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Browser
  programs.firefox.enable = true;

  # Korean input
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-hangul
        fcitx5-gtk
      ];
    };
  };

  fonts.fontconfig = {
    enable = true;
    antialias = true;
    hinting = {
      enable = true;
      style = "slight";
    };
    subpixel = {
      rgba = "rgb";
      lcdfilter = "default";
    };
    defaultFonts.monospace = [
      "JetBrainsMono Nerd Font"
    ];
  };
}
