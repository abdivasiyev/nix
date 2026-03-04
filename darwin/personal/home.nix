{
  pkgs,
  outputs,
  config,
  ...
}: let
in {
  home.packages = with pkgs; [
    docker
    docker-compose
    colima
    btop
    postman
    # disabled, becuase I migrated to Emacs
    # vscode
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
    jdk23
    shellcheck
    python3
    cloudflared
    pandoc
    yaml-language-server
    vscode-langservers-extracted
    cmake
    glibtool
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
    outputs.homeModules.zen
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
