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

            age.identityPaths = [ "/etc/agenix/identity" ];
            age.secrets.wg-cypher.file = ../../secrets/wg-cypher.age;

            systemd.services."wireguard-wg0" = {
              serviceConfig.ExecStartPre = [
                "${pkgs.bash}/bin/bash -c 'for i in {1..30}; do ${pkgs.busybox}/bin/nslookup captainhook.hosts.gisi.family >/dev/null 2>&1 && exit 0; sleep 1; done; echo \"DNS resolution failed for captainhook.hosts.gisi.family\" >&2; exit 1'"
              ];
            };

            networking.firewall.allowedUDPPorts = [ 51820 ];
            networking.wireguard.enable = true;
            networking.wireguard.interfaces = {
              wg0 = {
                ips = [ "10.100.0.2/24" ];
                listenPort = 51820;
                privateKeyFile = config.age.secrets.wg-cypher.path;

                peers = [
                  {
                    publicKey = "XZ+vkDoSI3QpkHUBjvGT8AnF5g4jn1TQHFhhWvIc1Tk=";
                    allowedIPs = [ "10.100.0.1/32" ];
                    endpoint = "captainhook.hosts.gisi.family:51820";
                    persistentKeepalive = 25;
                  }
                ];
              };
            };
          })

          ({ pkgs, lib, config, ... }: let
            myMinecraftServer = pkgs.minecraft-server.overrideAttrs (old: rec {
              version = "1.21.5";
              src = pkgs.fetchurl {
                url = "https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar";
                sha256 = "sha256-rnaB2tziG2tAF9KOfrVn2GtsEAppaZlPVAueVPgS3Ck=";
              };
            });
          in {
            networking.firewall.allowedTCPPorts = [ 25565 ];
            services.minecraft-server = {
              enable = true;
              package = myMinecraftServer;
              eula = true;
              declarative = true;
              serverProperties = {
                level-seed = "-2726085149442701246";
                motd = "Welcome to Gisi Island!";
                max-players = 4;
                gamemode = "survival";
                difficulty = 2;
              };
            };
          })
        ];
      };
    };
}
