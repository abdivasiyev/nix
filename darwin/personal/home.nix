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
    go
    gopls
    delve
    go-swag
    migrate
    nixd
    alejandra
    lua-language-server
    ripgrep
    natscli
    werf
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

  # TODO:
  # Decryption not worked for fresh installation
  # couldn't solve yet

  # # Install vpn configurations
  # home.activation.importSstpConfigOnce = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   if [ ! -f "${config.home.homeDirectory}/.config/first_runs/.sstp_done" ]; then
  #     mkdir -p "${config.home.homeDirectory}/.config/first_runs"
  #     touch "${config.home.homeDirectory}/.config/first_runs/.sstp_done"
  #     /usr/bin/open -a "SSTP Connect" "${config.home.homeDirectory}/.config/sstp/mobi.vpn"
  #   fi
  # '';
  #
  # home.activation.importTunnelblickConfigOnce = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   if [ ! -f "${config.home.homeDirectory}/.config/first_runs/.tunnelblick_done" ]; then
  #     /usr/bin/open -a "Tunnelblick" "${config.home.homeDirectory}/.config/tunnelblick/mobi.ovpn"
  #     mkdir -p "${config.home.homeDirectory}/.config/first_runs"
  #     touch "${config.home.homeDirectory}/.config/first_runs/.tunnelblick_done"
  #     /usr/bin/open -a "Tunnelblick" "${config.home.homeDirectory}/.config/tunnelblick/mobi.ovpn"
  #   fi
  # '';

  # Self installation of home-manager
  programs.home-manager.enable = true;

  # Shift when nixpkgs and nix-darwin shifts
  # But be prepared to update lotta configs
  home.stateVersion = "25.05";
}
