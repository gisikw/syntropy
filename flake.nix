{
  description = "Syntropy Homelab";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";
    deploy-rs.url = "github:serokell/deploy-rs";

    captainhook.url = "path:./hosts/captainhook";
  };

  outputs = inputs@{ nixpkgs, deploy-rs, captainhook, ... }:
    let
      inventory = import ./inventory.nix;

      hostDefs = [
        {
          name = "captainhook";
          system = inventory.captainhook.system;
          input = captainhook;
        }
      ];

      makeHost = { name, system, input }: {
        nixosConfigurations.${name} = input.nixosConfigurations.${name};
        deploy.nodes.${name} = {
          hostname = inventory.${name}.ip;
          sshUser = "syntropy";
          sshOpts = [ "-i" "~/.ssh/syntropy-deploy" ];
          profiles.system = {
            user = "root";
            remoteBuild = true;
            path = deploy-rs.lib.${system}.activate.nixos input.nixosConfigurations.${name};
          };
        };
      };

      merged = builtins.foldl' (acc: def: acc // makeHost def) {} hostDefs;

    in
      merged;
}
