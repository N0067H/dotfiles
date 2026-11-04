{ pkgs, ... }:

{
  # Alternate desktop with its own wallpaper, notifications, and idle tools.
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprlock
    hypridle
    hyprshot
    swaynotificationcenter
    networkmanagerapplet
  ];
}
