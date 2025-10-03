# Install nix

```bash
sh <(curl -L https://nixos.org/nix/install)
```

# Init nix-darwin

```bash
nix flake init -t nix-darwin/master --experimental-features 'nix-command flakes'
```

# Install darwin-rebuild

```bash
sudo nix run nix-darwin/master#darwin-rebuild --experimental-features 'nix-command flakes' -- switch --flake .#personal
```

# Switch to specific profile

```bash
sudo darwin-rebuild switch --flake .#personal
```

# Check flake

```bash
sudo darwin-rebuild check --flake .#personal
```
