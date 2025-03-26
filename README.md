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
nix run nix-darwin/master#darwin-rebuild --experimental-features 'nix-command flakes' -- switch --flakes ~/Development/nix#personal
```

# Switch to specific profile

```bash
darwin-rebuild switch --flake ~/Development/nix#personal
```

# Check flake

```bash
darwin-rebuild check --flake ~/Development/nix#personal
```
