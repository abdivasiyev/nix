{
  outputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    jetbrains.datagrip
	raycast
    docker
    colima
    telegram-desktop
    discord
    tree-sitter
    utm
    ripgrep
    rustup
    btop
    ghc
    haskellPackages.haskell-language-server
    postman
  ];

  # Modules
  imports = [
    outputs.homeModules.tmux
    outputs.homeModules.zsh
    outputs.homeModules.git
    outputs.homeModules.nvim
    outputs.homeModules.alacritty
    outputs.homeModules.go
    outputs.homeModules.eza
    outputs.homeModules.bat
    outputs.homeModules.carapace
  ];

  # Self installation of home-manager
  programs.home-manager.enable = true;

  # Shift when nixpkgs and nix-darwin shifts
  # But be prepared to update lotta configs
  home.stateVersion = "25.05";
}
