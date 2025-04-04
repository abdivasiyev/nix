check-flake:
  nix flake check --all-systems --show-trace

check-config:
  darwin-rebuild build --flake .#personal
