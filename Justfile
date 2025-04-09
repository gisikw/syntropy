deploy host:
  ip=$(grep {{host}} inventory.ini | sed 's/[[:space:]]//g' | cut -d= -f2); \
  nix run github:serokell/deploy-rs -- -d --hostname $ip --remote-build .#{{host}}
