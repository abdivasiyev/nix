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
            "${pkgs.kitty}/Applications/kitty.app"
            "${pkgs.vscode}/Applications/Visual Studio Code.app"
            "${pkgs.postman}/Applications/Postman.app"
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
          "com.apple.Safari" = {
            # Privacy: don’t send search queries to Apple
            UniversalSearchEnabled = false;
            SuppressSearchSuggestions = true;
            # Press Tab to highlight each item on a web page
            WebKitTabToLinksPreferenceKey = true;
            ShowFullURLInSmartSearchField = true;

            ShowOverlayStatusBar = true;
            AlwaysRestoreSessionAtLaunch = true;
            AutoOpenSafeDownloads = false;
            IncludeDevelopMenu = true;
            IncludeInternalDebugMenu = true;
            HomePage = "about:blank";

            ShowFavoritesBar = false;
            WebKitDeveloperExtrasEnabledPreferenceKey = true;
            WebContinuousSpellCheckingEnabled = true;
            WebAutomaticSpellingCorrectionEnabled = false;
            AutoFillFromAddressBook = false;
            AutoFillCreditCardData = false;
            AutoFillMiscellaneousForms = false;
            WarnAboutFraudulentWebsites = true;
            WebKitJavaEnabled = false;
            WebKitJavaScriptCanOpenWindowsAutomatically = false;
            "com.apple.Safari.ContentPageGroupIdentifier.WebKit2TabsToLinks" = true;
            "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
            "com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled" = false;
            "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled" = false;
            "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles" = false;
            "com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically" = false;
          };
          "com.apple.AdLib" = {
            allowApplePersonalizedAdvertising = false;
          };
        };
      };
    };
  };
}
