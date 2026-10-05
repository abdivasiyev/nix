{den, ...}: {
  den.aspects.profiles.personal = {
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
      development.btop
      development.direnv
      development.eza
      development.git
      development.kitty
      development.nix
      development.nur
      development.ssh
      development.tmux
      development.zsh

      # www
      www.zen
      # desktop
      desktop.darwin
    ];
  };
}
