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

## NixOS VM `midi` (OrbStack)

An aarch64 NixOS machine in OrbStack for building Linux-only projects. i3 runs on a
virtual X server (TigerVNC) because OrbStack machines have no display.

1. Create the machine (OrbStack mounts `/Users` inside it)

```bash
orb create nixos midi
```

2. Copy the sops age key into the guest

```bash
orb -m midi bash -c 'mkdir -p ~/.config/sops/age && install -m 600 /Users/abdivasiyev/.config/sops/age/keys.txt ~/.config/sops/age/'
```

3. Make sure `vncPassword` exists in `secrets/secrets.yaml` (VNC uses only the first 8 characters)

4. Switch, from the repo path as seen inside the guest

```bash
orb -m midi sudo nixos-rebuild switch --flake /Users/abdivasiyev/Development/git.azizovich.uz/abdivasiyev/worktrees/nix/master#midi
```

5. Connect with TigerVNC Viewer (installed by the `orbstack` aspect) to the guest's IP,
port 5901. macOS Screen Sharing doesn't work: it sends Option+letter as composed
characters (Option+D = ∂).

```bash
orb -m midi ip -4 -o addr show eth0
```

Keys inside the VM (Xvnc runs with `-RawKeyboard`, so keys arrive as on the Mac):

- Cmd is the i3 modifier: Cmd+Return kitty, Cmd+D dmenu, Cmd+B Zen,
  Cmd+H/J/K/L focus, Cmd+Shift+H/J/K/L move, Cmd+G / Cmd+V split, Cmd+R resize
- Option is Meta in Emacs, as on macOS
- The clipboard is synced with the Mac through OrbStack's `mac pbcopy`/`pbpaste`

`modules/hosts/midi/_orbstack/` holds OrbStack's generated NixOS config. If OrbStack
regenerates `/etc/nixos/orbstack.nix` after an update, copy the new version there.
