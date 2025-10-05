{
  pkgs,
  lib,
  outputs,
  config,
  ...
}: {
  home.packages = with pkgs; [
      docker
      colima
      telegram-desktop
      btop
      postman
      vscode
      age
      sops
      kubectl
      awscli2
      inetutils
      jq
      go
      gopls
  ];

  # Modules
  imports = [
    outputs.homeModules.tmux
    outputs.homeModules.zsh
    outputs.homeModules.git
    outputs.homeModules.kitty
    outputs.homeModules.eza
    outputs.homeModules.bat
    outputs.homeModules.secret
    outputs.homeModules.vscode
    outputs.homeModules.nvim
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
  };

  # Install vpn configurations
  home.activation.importSstpConfigOnce = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "${config.home.homeDirectory}/.config/first_runs/.sstp_done" ]; then
      mkdir -p "${config.home.homeDirectory}/.config/first_runs"
      touch "${config.home.homeDirectory}/.config/first_runs/.sstp_done"
      /usr/bin/open -a "SSTP Connect" "${config.home.homeDirectory}/.config/sstp/mobi.vpn"
    fi
  '';

  home.activation.importTunnelblickConfigOnce = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "${config.home.homeDirectory}/.config/first_runs/.tunnelblick_done" ]; then
      /usr/bin/open -a "Tunnelblick" "${config.home.homeDirectory}/.config/tunnelblick/mobi.ovpn"
      mkdir -p "${config.home.homeDirectory}/.config/first_runs"
      touch "${config.home.homeDirectory}/.config/first_runs/.tunnelblick_done"
      /usr/bin/open -a "Tunnelblick" "${config.home.homeDirectory}/.config/tunnelblick/mobi.ovpn"
    fi
  '';

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
