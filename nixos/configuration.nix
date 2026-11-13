{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/desktop.nix
    ./modules/docker.nix
    ./modules/kubernetes.nix
    ./modules/packages.nix
    ./modules/services.nix
    ./modules/shell.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.bootvine.enable = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  users.users.noobth = {
    isNormalUser = true;
    description = "noobth";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  time.timeZone = "Asia/Seoul";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ko_KR.UTF-8";
    LC_IDENTIFICATION = "ko_KR.UTF-8";
    LC_MEASUREMENT = "ko_KR.UTF-8";
    LC_MONETARY = "ko_KR.UTF-8";
    LC_NAME = "ko_KR.UTF-8";
    LC_NUMERIC = "ko_KR.UTF-8";
    LC_PAPER = "ko_KR.UTF-8";
    LC_TELEPHONE = "ko_KR.UTF-8";
    LC_TIME = "ko_KR.UTF-8";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Preserve the compatibility baseline across refactors and Nixpkgs upgrades.
  system.stateVersion = "26.05";
}
