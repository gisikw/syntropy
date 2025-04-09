{
  inputs.shared.url = "path:../../shared";
  inputs.nixpkgs.url = "nixpkgs/nixos-24.11";
  inputs.agenix.url = "github:ryantm/agenix";

  outputs = { shared, nixpkgs, agenix, ... }:
    {
      nixosConfigurations.cypher = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          agenix.nixosModules.default
          shared.modules.core
          shared.modules.hardware.beelink

          ({ pkgs, config, ... }: {
            networking.hostName = "cypher";
            system.stateVersion = "24.11";
          })
        ];
      };
    };
}
