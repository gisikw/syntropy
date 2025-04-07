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
      hostDefs = [
        {
          name = "captainhook";
          input = captainhook;
        }
      ];

      makeHost = { name, input }: {
        nixosConfigurations.${name} = input.nixosConfigurations.${name};
        deploy.nodes.${name} = {
          hostname = "<redacted>"; # Real host passed via CLI
          sshUser = "syntropy";
          sshOpts = [ "-i" "~/.ssh/syntropy-deploy" ];
          profiles.system = {
            user = "root";
            remoteBuild = true;
            path = deploy-rs.lib.${input.nixosConfigurations.${name}.config.nixpkgs.system}.activate.nixos
              input.nixosConfigurations.${name};
          };
        };
      };

      merged = builtins.foldl' (acc: def: acc // makeHost def) {} hostDefs;

    in
      merged;
}
