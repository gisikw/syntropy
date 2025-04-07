deploy host:
  ip=$(grep captainhook inventory.ini | sed 's/[[:space:]]//g' | cut -d= -f2); \
  nix run github:serokell/deploy-rs -- --hostname $ip --remote-build .#{{host}}
