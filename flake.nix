{
  description = "noobth NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    bootvine = {
      url = "git+https://codeberg.org/wvhulle/bootvine";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Keep upstream's nixpkgs pin for compatibility and binary cache hits.
    llm-agents.url = "github:numtide/llm-agents.nix";

    codex-desktop.url = "github:ilysenko/codex-desktop-linux";
    driftwm.url = "github:malbiruk/driftwm";
    noctalia.url = "github:noctalia-dev/noctalia/v5.4.1";
  };

  outputs = { self, nixpkgs, bootvine, llm-agents, codex-desktop, driftwm, noctalia, ... }:
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
          bootvine.nixosModules.default
          driftwm.nixosModules.default

          ({ pkgs, ... }: {
            nix.settings = {
              extra-substituters = [ "https://cache.numtide.com" ];
              extra-trusted-public-keys = [
                "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
              ];
            };
            environment.systemPackages = [
              codex-desktop.packages.${system}.default
              llm-agents.packages.${system}.default
            ];
          })
        ];
      };
    };
}
