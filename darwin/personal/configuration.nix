{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  # Import your modules here
  imports = [
    # Abstraction from repos
    inputs.home-manager.darwinModules.home-manager

    # Personal modules
    outputs.darwinPersonalModules.brew
    outputs.darwinPersonalModules.users
    outputs.darwinPersonalModules.system
    outputs.darwinPersonalModules.secret
  ];

  nix = {
    enable = false;
  };

  # Allow not open source packages
  # E.g: google-chrome, jetbrains
  nixpkgs.config.allowUnfree = true;

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
