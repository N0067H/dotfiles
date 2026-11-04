{ pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    ensureDatabases = [ "mydatabase" ];
  };
  services.tailscale.enable = true;
  services.cloudflare-warp.enable = true;

  systemd.services.battery-charge-threshold = {
    description = "Set battery charge threshold to 80%";

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };

    script = ''
      if [ -e /sys/class/power_supply/BAT0/charge_control_end_threshold ]; then
        echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold
      fi
    '';
  };
}
