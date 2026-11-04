{
  description = "noobth NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    codex-desktop.url = "github:ilysenko/codex-desktop-linux";
    driftwm.url = "github:malbiruk/driftwm";
    noctalia.url = "github:noctalia-dev/noctalia/v5.4.1";
  };

  outputs = { self, nixpkgs, codex-desktop, driftwm, noctalia, ... }:
    let
      system = "x86_64-linux";
    in {
      devShells.${system}.default = let
        pkgs = nixpkgs.legacyPackages.${system};
      in pkgs.mkShell {
        buildInputs = with pkgs; [
          openssl
        ];
      };

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit codex-desktop noctalia;
        };

        modules = [
          ./nixos/configuration.nix
          driftwm.nixosModules.default

          ({ pkgs, ... }: {
            environment.systemPackages = [
              codex-desktop.packages.${system}.default
            ];
          })
        ];
      };
    };
}
