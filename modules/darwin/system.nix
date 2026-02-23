{pkgs, ...}: {
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
          tilesize = 42;
          magnification = true;
          persistent-apps = [
            "/System/Applications/Apps.app"
            "/System/Applications/Mail.app"
            "/System/Applications/Photos.app"
            "/System/Applications/Messages.app"
            "/System/Applications/Calendar.app"
            "/Applications/SSTP Connect.app"
            "/Applications/Tunnelblick.app"
            "/Applications/Redis Insight.app"
            "/Applications/Lens.app"
            "/System/Cryptexes/App/System/Applications/Safari.app"
            "/Applications/Telegram Desktop.app"
            # "${pkgs.vscode}/Applications/Visual Studio Code.app"
            "/Applications/Emacs.app"
            "${pkgs.postman}/Applications/Postman.app"
            "/System/Applications/Books.app"
          ];
        };

        CustomUserPreferences = {
          NSGlobalDomain = {
            # Set to dark mode
            AppleInterfaceStyle = "Dark";

            WebKitDeveloperExtras = true;
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
          "com.microsoft.VSCode" = {
            ApplePressAndHoldEnabled = false;
          };
        };
      };
    };

    services = {
      openssh = {
        enable = true;
      };
    };
  };
}
