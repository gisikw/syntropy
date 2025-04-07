deploy host:
  nix run github:serokell/deploy-rs -- --remote-build .#{{host}}
