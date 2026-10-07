{
  inputs,
  den,
  ...
}: {
  den.aspects.profiles.work = {
    includes = with den.aspects; [
      # global packages
      packages.homebrew
      packages.system

      # secret management
      secrets.sops
      secrets.bitwarden

      # editors
      editors.emacs

      # chat
      chat.telegram
      chat.discord
      chat.element

      # development environment
      development.bat
      development.bruno
      development.btop
      development.direnv
      development.eza
      development.git
      development.jetbrains-toolbox
      development.k8s
      development.kitty
      development.nats
      development.nix
      development.nur
      development.orbstack
      development.redis
      development.ssh
      development.tmux
      development.tunnelblick
      development.sstp
      development.zsh

      # www
      www.zen
      # desktop
      desktop.darwin
      desktop.fonts
      desktop.better-display
      desktop.macs-fan-control
      desktop.vlc

      # llm
      llm.claude
    ];
  };
}
