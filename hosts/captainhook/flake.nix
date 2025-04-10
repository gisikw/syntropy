{
  inputs.shared.url = "path:../../shared";
  inputs.nixpkgs.url = "nixpkgs/nixos-24.11";
  inputs.agenix.url = "github:ryantm/agenix";

  outputs = { shared, nixpkgs, agenix, ... }:
    {
      nixosConfigurations.captainhook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          agenix.nixosModules.default
          shared.modules.core
          shared.modules.hardware.linode

          ({ pkgs, config, ... }: {
            networking.hostName = "captainhook";
            system.stateVersion = "24.11";

            age.identityPaths = [ "/etc/agenix/identity" ];
            age.secrets.wg-captainhook.file = ../../secrets/wg-captainhook.age;

            networking.nat.enable = true;
            networking.nat.externalInterface = "eth0";
            networking.nat.internalInterfaces = [ "wg0" ];
            networking.firewall = {
              allowedUDPPorts = [ 51820 ];
            };
            networking.wireguard.enable = true;
            networking.wireguard.interfaces = {
              wg0 = {
                ips = [ "10.100.0.1/24" ];

                listenPort = 51820;
                privateKeyFile = config.age.secrets.wg-captainhook.path;
                peers = [{
                  publicKey = "6FJUNS3ScDxAOwBCYt9I6g0zVDBAT9MPelncPows+R8=";
                  allowedIPs = [ "10.100.0.2/32" ];
                }];
              };
            };
          })
        ];
      };
    };

}
