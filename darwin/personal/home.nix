{
  pkgs,
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
    cloudflared
    glibtool
    asciinema
  ];

  # Modules
  imports = [
    outputs.homeModules.tmux
    outputs.homeModules.zsh
    outputs.homeModules.git
    outputs.homeModules.worktree
    outputs.homeModules.eza
    outputs.homeModules.bat
    outputs.homeModules.secret
    # outputs.homeModules.vscode
    outputs.homeModules.nvim
    outputs.homeModules.starship
    outputs.homeModules.emacs
    outputs.homeModules.xdg

    # zen browser
    outputs.homeModules.zen
    outputs.homeModules.rbw
    outputs.homeModules.ssh
    outputs.homeModules.homelabLan
    outputs.homeModules.homelab
    outputs.homeModules.kitty
    outputs.homeModules.btop
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
