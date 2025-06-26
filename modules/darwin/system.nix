{...}: {
  config = {
    system = {
      activationScripts.script.text = ''
        # Following line should allow us to avoid a logout/login cycle
        /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
      '';

	  primaryUser = "abdivasiyev";

      keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
      };

      defaults = {
        dock = {
          show-recents = false;
          tilesize = 48;
          magnification = true;
        };

        CustomUserPreferences = {
          "com.apple.symbolichotkeys" = {
            AppleSymbolicHotKeys = {
              # Disable 'Cmd + Space' for Spotlight Search
              # "64" = {
              #   enabled = false;
              # };
              # Disable 'Cmd + Alt + Space' for Finder search window
              # "65" = {
              #   enabled = false;
              # };
            };
          };
          "com.apple.finder" = {
            ShowExternalHardDrivesOnDesktop = false;
            ShowHardDrivesOnDesktop = false;
            ShowMountedServersOnDesktop = false;
            ShowRemovableMediaOnDesktop = false;
            _FXSortFoldersFirst = true;
            # When performing a search, search the current folder by default
            FXDefaultSearchScope = "SCcf";
          };
        };
      };
    };
  };
}
