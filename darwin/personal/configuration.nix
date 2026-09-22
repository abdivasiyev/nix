{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  # Import your modules here
  imports = [
    # Abstraction from repos
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.home-manager.darwinModules.home-manager

    # Personal modules
    outputs.darwinPersonalModules.brew
    outputs.darwinPersonalModules.users
    outputs.darwinPersonalModules.system
    outputs.darwinPersonalModules.secret
    outputs.darwinPersonalModules.cache
    outputs.darwinPersonalModules.homelabLan
    outputs.darwinPersonalModules.homelabMachine
    outputs.darwinPersonalModules.cachePush
  ];

  nix = {
    enable = false;
  };

  # This Mac runs the homelab (OrbStack): reach it on loopback, and open its
  # home entrances to the LAN for the other Macs.
  homelab.lan = {
    server = "127.0.0.1";
    forward = true;
    # The home network's DNS address: fixed here rather than by a router
    # reservation, which macOS's per-network private MAC keeps invalidating.
    staticAddress = "192.168.1.81";
  };

  # OrbStack restores the machine a minute after login and gives up if the
  # external disk has not mounted yet -- which is what kept the homelab down
  # for six hours after the 22 September power cut. Wait for the disk, then
  # start it.
  homelab.machine = {
    enable = true;
    requires = [
      "/Volumes/Asliddin/Media"
      "/Volumes/Asliddin/Backups"
    ];
  };

  # Allow not open source packages
  # E.g: google-chrome, jetbrains
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
    overlays = outputs.overlays;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Nix-darwin doing some shenanigans for stability of options
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Nix-darwin related stuff
  # Change when you're ready to upgrade nix-darwin version
  system.stateVersion = 5;

  # Indicate for what platform nix should derive packages
  nixpkgs.hostPlatform = "aarch64-darwin";
}
