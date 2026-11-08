{ pkgs, noctalia, ... }:

{
  # 0.8.3 fixes Steam popup menus closing immediately under Xwayland.
  # Remove this override once the pinned nixpkgs includes the fix.
  nixpkgs.overlays = [
    (final: prev: {
      xwayland-satellite = prev.xwayland-satellite.overrideAttrs (old: rec {
        version = "0.8.3";
        src = final.fetchFromGitHub {
          owner = "Supreeeme";
          repo = "xwayland-satellite";
          tag = "v${version}";
          hash = "sha256-eFEjCCniMCKeWU0PcZNv+tDYe08SLFPjRplyPY8OFt4=";
        };
        cargoDeps = final.rustPlatform.fetchCargoVendor {
          inherit src;
          name = "xwayland-satellite-${version}-vendor";
          hash = "sha256-gMGFvnbxM3hD5fmkSimaFd87GEf6BXFe/MGjoS6VNVU=";
        };
        meta = old.meta // {
          changelog = "https://github.com/Supreeeme/xwayland-satellite/releases/tag/v${version}";
        };
      });
    })
  ];

  # Primary desktop. Rofi remains the clipboard picker.
  programs.niri.enable = true;
  environment.systemPackages = [
    noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.swaylock
    pkgs.xwayland-satellite
  ];
}
