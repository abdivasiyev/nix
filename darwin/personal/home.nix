{
  pkgs,
  outputs,
  config,
  ...
}: let
  hpkgs = pkgs.haskell.packages."ghc912";
in {
  home.packages = with pkgs; [
    docker_29
    docker-compose
    colima
    btop
    age
    sops
    kubectl
    awscli2
    inetutils
    jq
    nixd
    alejandra
    lua-language-server
    ripgrep
    jdk25
    shellcheck
    python3
    cloudflared
    pandoc
    yaml-language-server
    vscode-langservers-extracted
    cmake
    glibtool
    asciinema

    # Haskell stuff
    hpkgs.cabal-install
    hpkgs.cabal-add
    hpkgs.cabal-gild
    hpkgs.haskell-language-server
    hpkgs.fourmolu
    hpkgs.ghc
    hpkgs.ghcide
  ];

  # Modules
  imports = [
    outputs.homeModules.tmux
    outputs.homeModules.zsh
    outputs.homeModules.git
    outputs.homeModules.eza
    outputs.homeModules.bat
    outputs.homeModules.secret
    # outputs.homeModules.vscode
    outputs.homeModules.nvim
    outputs.homeModules.starship
    outputs.homeModules.emacs
    outputs.homeModules.xdg
  ];

  sops.secrets = {
    sshPrivateKey = {
      sopsFile = ../../secrets/secrets.yaml;
      format = "yaml";
      path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      mode = "0600";
    };
    githubToken = {
      sopsFile = ../../secrets/secrets.yaml;
      format = "yaml";
      path = "${config.home.homeDirectory}/.config/nix/github_token";
      mode = "0400";
    };
  };

  # Self installation of home-manager
  programs.home-manager.enable = true;

  # Shift when nixpkgs and nix-darwin shifts
  # But be prepared to update lotta configs
  home.stateVersion = "25.05";
}
