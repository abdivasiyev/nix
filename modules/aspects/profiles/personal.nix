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
      local.dock.entries = let
        zen = inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight;
        programs = config.home-manager.users.abdivasiyev.programs;
        emacs = programs.emacs.finalPackage;
      in [
        {path = "/System/Applications/Apps.app";}
        {path = "/System/Applications/Mail.app";}
        {path = "/System/Applications/Photos.app";}
        {path = "/System/Applications/Messages.app";}
        {path = "/System/Applications/Calendar.app";}
        {path = "/Applications/Redis Insight.app";}
        {path = "/System/Cryptexes/App/System/Applications/Safari.app";}
        {path = "${zen}/Applications/${zen.applicationName}.app";}
        {path = "/Applications/Telegram Desktop.app";}
        {path = "/Applications/Element.app";}
        {path = "/Applications/Discord.app";}
        {path = "${emacs}/Applications/Emacs.app";}
        {path = "/Applications/Bruno.app";}
        {path = "/Applications/OrbStack.app";}
        {path = "/Applications/Bitwarden.app";}
        {path = "${pkgs.kitty}/Applications/kitty.app";}
      ];
    };
  };
}
