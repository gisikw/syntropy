{
  inputs.shared.url = "path:../../shared";
  inputs.nixpkgs.url = "nixpkgs/nixos-24.11";

  outputs = { shared, nixpkgs, ... }:
    {
      nixosConfigurations.captainhook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          shared.modules.core
          shared.modules.hardware.linode

          ({ pkgs, config, ... }: {
            networking.hostName = "captainhook";
            system.stateVersion = "24.11";
          })
        ];
      };
    };
}
