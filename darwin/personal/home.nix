{
  lib,
  outputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    docker
    colima
    telegram-desktop
    btop
    postman
    vscode
  ];

  # Modules
  imports = [
    outputs.homeModules.tmux
    outputs.homeModules.zsh
    outputs.homeModules.git
    outputs.homeModules.kitty
    outputs.homeModules.go
    outputs.homeModules.eza
    outputs.homeModules.bat
  ];

  # Link .app bundles into ~/Applications/Nix-Apps
  home.activation.linkApps = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/Applications/Nix-Apps
    for app in $HOME/.nix-profile/Applications/*.app; do
      ln -sf "$app" ~/Applications/Nix-Apps/
    done
  '';

  # Self installation of home-manager
  programs.home-manager.enable = true;

  # Shift when nixpkgs and nix-darwin shifts
  # But be prepared to update lotta configs
  home.stateVersion = "25.05";
}
