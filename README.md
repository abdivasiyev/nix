# Nix based host configurations

Configurations are written using [den](https://den.denful.dev)

Inspired by [aeshakhzod](https://codeberg.org/aeshakhzod/blazingly-fast/)

Installation

1. Install nix or determinate nix

```bash
sh <(curl -L https://nixos.org/nix/install)

# determinate nix installation
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

2. Install nix-darwin's darwin-rebuild command

```
sudo nix run nix-darwin/master#darwin-rebuild --experimental-features 'nix-command flakes' -- switch --flake .#personal
```

3. Copy sops secret key

```bash
cp ~/Documents/keys/sops/age/keys.txt ~/.config/sops/age/keys.txt
```

4. Switch to specific host (available `maxi` and `mini`)

```
sudo darwin-rebuild switch --flake .#maxi
```

5. Editing secrets

```
EDITOR=vim SOPS_AGE_KEY_FILE=~/.config/sops/age/keys.txt sops --age -e secrets/secrets.yaml
```

## NixOS VM `midi` (UTM)

Push the config first: the VM installs from `github:abdivasiyev/nix#midi`.

```bash
./scripts/midi.sh
```

Type the password in the VM window when asked. `~/Development` is shared at `~/share`.
