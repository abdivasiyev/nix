{
  den.aspects.desktop.darwin = {
    darwin = {
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
    };
  };
}
