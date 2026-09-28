{ ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  users.users.noobth.extraGroups = [ "docker" ];
}
