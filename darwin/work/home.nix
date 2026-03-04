{
  pkgs,
  # lib,
  outputs,
  config,
  ...
}: let
  # hpkgs = pkgs.haskell.packages."ghc910";
  migrate = pkgs.go-migrate.overrideAttrs (oldAttrs: {
    tags = ["postgres"];
  });
in {
  home.packages = with pkgs; [
    docker
    docker-compose
    colima
    age
    sops
    kubectl
    awscli2
    inetutils
    jq
    go
    gopls
    delve
    go-swag
    migrate
    nixd
    alejandra
    ripgrep
    natscli
    werf
    jdk23
    shellcheck
    python3
    pandoc
    yaml-language-server
    vscode-langservers-extracted
    cmake
    glibtool
    wget
  ];

  # Modules
  imports = [
    outputs.homeModules.zsh
    outputs.homeModules.git
    outputs.homeModules.eza
    outputs.homeModules.bat
    outputs.homeModules.secret
    outputs.homeModules.nvim
    outputs.homeModules.starship
    outputs.homeModules.emacs
    outputs.homeModules.xdg
    outputs.homeModules.zen
  ];

  sops.secrets = {
    kubeconfig = {
      sopsFile = ../../secrets/secrets.yaml;
      format = "yaml";
      path = "${config.home.homeDirectory}/.kube/config";
      mode = "0400";
    };
    awsConfig = {
      sopsFile = ../../secrets/secrets.yaml;
      format = "yaml";
      path = "${config.home.homeDirectory}/.aws/config";
      mode = "0400";
    };
    awsCredentials = {
      sopsFile = ../../secrets/secrets.yaml;
      format = "yaml";
      path = "${config.home.homeDirectory}/.aws/credentials";
      mode = "0400";
    };
    mobiVpn = {
      sopsFile = ../../secrets/secrets.yaml;
      format = "yaml";
      path = "${config.home.homeDirectory}/.config/sstp/mobi.vpn";
      mode = "0400";
    };
    mobiTunnelblick = {
      sopsFile = ../../secrets/secrets.yaml;
      format = "yaml";
      path = "${config.home.homeDirectory}/.config/tunnelblick/mobi.ovpn";
      mode = "0400";
    };
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
