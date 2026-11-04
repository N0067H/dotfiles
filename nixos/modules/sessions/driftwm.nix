{ pkgs, ... }:

{
  # Experimental session, independent of the primary desktop.
  programs.driftwm.enable = true;
  environment.systemPackages = [ pkgs.swaybg ];
}
