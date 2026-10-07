{den, ...}: {
  den.aspects.profiles.linux = {
    includes = with den.aspects; [
      # global packages
      packages.system

      # secret management
      secrets.sops

      # editors
      editors.emacs

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
      desktop.fonts
      desktop.i3
    ];
  };
}
