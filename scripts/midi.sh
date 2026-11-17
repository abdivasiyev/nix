#!/usr/bin/env bash
set -euo pipefail

name=midi
iso="$HOME/Downloads/latest-nixos-minimal-aarch64-linux.iso"
share="$HOME/Development"
key="$HOME/.config/sops/age/keys.txt"

install="sudo sh -c 'parted -s /dev/vda -- mklabel gpt mkpart ESP fat32 1MiB 1GiB set 1 esp on mkpart root ext4 1GiB 100% \
&& mkfs.fat -F 32 -n boot /dev/vda1 && mkfs.ext4 -F -L nixos /dev/vda2 && udevadm settle \
&& mount /dev/disk/by-label/nixos /mnt && mount --mkdir -o umask=077 /dev/disk/by-label/boot /mnt/boot \
&& nixos-install --no-root-passwd --flake github:abdivasiyev/nix#midi \
&& nixos-enter --root /mnt -c \"passwd abdivasiyev\" && reboot'
"

[ -f "$iso" ] || curl -fL -o "$iso" https://channels.nixos.org/nixos-26.05/latest-nixos-minimal-aarch64-linux.iso

osascript - "$name" "$iso" "$share" <<'EOF'
on run argv
  tell application "UTM"
    set iso to POSIX file (item 2 of argv)
    set share to POSIX file (item 3 of argv)
    set vm to make new virtual machine with properties {backend:qemu, configuration:{name:(item 1 of argv), architecture:"aarch64", memory:8192, cpu cores:4, directory share mode:VirtFS, displays:{{hardware:"virtio-gpu-gl-pci", native resolution:true}}, drives:{{removable:true, source:iso}, {interface:VirtIO, guest size:65536}}}}
    update registry vm with {share}
  end tell
end run
EOF

utmctl start "$name"
sleep 90

osascript - "$name" "$install" <<'EOF'
on run argv
  tell application "UTM" to input keystroke virtual machine (item 1 of argv) text (item 2 of argv)
end run
EOF

echo "Set the password in the $name window. Waiting for the installed system..."
until ip=$(utmctl ip-address "$name" 2>/dev/null | grep -m1 -E '^[0-9.]+$') &&
  ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new "abdivasiyev@$ip" true 2>/dev/null; do
  sleep 10
done

ssh "abdivasiyev@$ip" 'install -d -m 700 ~/.config/sops/age && install -m 600 /dev/stdin ~/.config/sops/age/keys.txt && systemctl --user restart sops-nix' <"$key"
echo "$name is ready at $ip"
