{
  pkgs,
  # lib,
  outputs,
  config,
  ...
}: {
  targets.darwin.copyApps.enable = true;
  targets.darwin.linkApps.enable = false;

  home.packages = with pkgs; [
    age
    sops
    kubectl
    kubectl-readonly
    awscli2
    inetutils
    jq
    ripgrep
    natscli
    werf
    glibtool
    cloudflared
  ];

  # Modules
  imports = [
    outputs.homeModules.zsh
    outputs.homeModules.git
    outputs.homeModules.worktree
    outputs.homeModules.eza
    outputs.homeModules.bat
    outputs.homeModules.secret
    outputs.homeModules.nvim
    outputs.homeModules.starship
    outputs.homeModules.emacs
    outputs.homeModules.xdg
    outputs.homeModules.zen
    outputs.homeModules.rbw
    outputs.homeModules.ssh
    outputs.homeModules.homelabLan
    outputs.homeModules.kitty
    outputs.homeModules.btop
    outputs.homeModules.tmux
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
