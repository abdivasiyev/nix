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
    outputs.darwinModules.brew
    outputs.darwinModules.users
    outputs.darwinModules.system
  ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
  };

  # Allow not open source packages
  # E.g: google-chrome, jetbrains
  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    jetbrains-mono
  ];

  # Nix-darwin doing some shenanigans for stability of options
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Nix-darwin related stuff
  # Change when you're ready to upgrade nix-darwin version
  system.stateVersion = 5;

  # Indicate for what platform nix should derive packages
  nixpkgs.hostPlatform = "aarch64-darwin";
}
