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
      development.btop
      development.direnv
      development.eza
      development.git
      development.k8s
      development.kitty
      development.nats
      development.nix
      development.nur
      development.ssh
      development.tmux
      development.tunnelblick
      development.sstp
      development.zsh

      # www
      www.zen
      # desktop
      desktop.darwin
      desktop.dock
      desktop.fonts
    ];

    # Darwin dock setup
    darwin = {
      pkgs,
      config,
      ...
    }: {
      local.dock.entries = let
        zen = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight;
        programs = config.home-manager.users.abdivasiyev.programs;
        emacs = programs.emacs.finalPackage;
      in [
        {path = "/System/Applications/Apps.app";}
        {path = "/System/Applications/Mail.app";}
        {path = "/System/Applications/Messages.app";}
        {path = "/System/Applications/Calendar.app";}
        {path = "/Applications/SSTP Connect.app";}
        {path = "/Applications/Tunnelblick.app";}
        {path = "/Applications/Lens.app";}
        {path = "/Applications/Redis Insight.app";}
        {path = "/System/Cryptexes/App/System/Applications/Safari.app";}
        {path = "${zen}/Applications/${zen.applicationName}.app";}
        {path = "/Applications/Telegram Desktop.app";}
        {path = "/Applications/Element.app";}
        {path = "${emacs}/Applications/Emacs.app";}
        {path = "/Applications/Bruno.app";}
        {path = "/Applications/OrbStack.app";}
        {path = "/Applications/Bitwarden.app";}
        {path = "${pkgs.kitty}/Applications/kitty.app";}
      ];
    };
  };
}
