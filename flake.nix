{
  description = "noobth NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    codex-desktop.url = "github:ilysenko/codex-desktop-linux";
  };

  outputs = { self, nixpkgs, codex-desktop, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit codex-desktop;
        };

        modules = [
          ./nixos/configuration.nix

          ({ pkgs, ... }: {
            environment.systemPackages = [
              codex-desktop.packages.${system}.default
            ];
          })
        ];
      };
    };
}
