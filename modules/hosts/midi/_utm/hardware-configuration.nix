{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
    "nvme"
    "usbhid"
    "usb_storage"
    "sr_mod"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  fileSystems."/mnt/share" = {
    device = "share";
    fsType = "9p";
    options = ["trans=virtio" "version=9p2000.L" "nofail" "x-systemd.automount"];
  };

  fileSystems."/home/abdivasiyev/share" = {
    device = "/mnt/share";
    fsType = "fuse.bindfs";
    noCheck = true;
    depends = ["/mnt/share"];
    options = ["map=501/abdivasiyev:@20/@users" "nofail" "x-systemd.automount"];
  };
}
