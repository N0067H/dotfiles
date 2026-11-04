{ pkgs, noctalia, ... }:

{
  # Primary desktop. Rofi remains the clipboard picker.
  programs.niri.enable = true;
  environment.systemPackages = [
    noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.swaylock
    pkgs.xwayland-satellite
  ];
}
