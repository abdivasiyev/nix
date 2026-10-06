{
  inputs,
  den,
  ...
}: {
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
      desktop.fonts
    ];

    # Darwin dock setup
    darwin = {
      pkgs,
      config,
      ...
    }: {
      system.defaults.dock.persistent-apps = let
        zen = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight;
        programs = config.home-manager.users.abdivasiyev.programs;
        emacs = programs.emacs.finalPackage;
      in [
        "/System/Applications/Apps.app"
        "/System/Applications/Mail.app"
        "/System/Applications/Photos.app"
        "/System/Applications/Messages.app"
        "/System/Applications/Calendar.app"
        "/Applications/Redis Insight.app"
        "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app"
        "${zen}/Applications/${zen.applicationName}.app"
        "/Applications/Telegram Desktop.app"
        "/Applications/Element.app"
        "/Applications/Discord.app"
        "${emacs}/Applications/Emacs.app"
        "/Applications/Bruno.app"
        "/Applications/OrbStack.app"
        "/Applications/Bitwarden.app"
        "${pkgs.kitty}/Applications/kitty.app"
      ];
    };
  };
}
