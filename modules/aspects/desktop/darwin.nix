{
  inputs,
  den,
  ...
}: {
  den.aspects.desktop.darwin = {
    includes = [
      den.aspects.desktop.dock
    ];

    darwin = {
      pkgs,
      config,
      ...
    }: {
      system = {
        keyboard = {
          enableKeyMapping = true;
          remapCapsLockToEscape = true;
        };
        defaults = {
          dock = {
            show-recents = false;
            tilesize = 42;
            magnification = true;
            orientation = "bottom";
            mru-spaces = false;
          };

          CustomUserPreferences = {
            NSGlobalDomain = {
              AppleShowAllExtensions = true;
              # Set to dark mode
              AppleInterfaceStyle = "Dark";

              WebKitDeveloperExtras = true;

              "com.apple.swipescrolldirection" = false; # True for "natural" scrolling direction
            };

            "com.apple.finder" = {
              ShowExternalHardDrivesOnDesktop = false;
              ShowHardDrivesOnDesktop = false;
              ShowMountedServersOnDesktop = false;
              ShowRemovableMediaOnDesktop = false;
              _FXSortFoldersFirst = true;
              # When performing a search, search the current folder by default
              FXDefaultSearchScope = "SCcf";
              QLEnableTextSelection = true;
              FXPreferredViewStyle = "clmv";
            };
            "com.apple.AdLib" = {
              allowApplePersonalizedAdvertising = false;
            };
          };
        };
      };

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
