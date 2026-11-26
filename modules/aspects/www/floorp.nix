{
  den.aspects.www.floorp = {
    # nixpkgs' floorp-bin breaks the app's code signature on macOS and the
    # system kills it at launch, so the signed app comes from Homebrew.
    darwin = {
      homebrew.casks = ["floorp"];
      system.defaults.dock.persistent-apps = [
        "/Applications/Floorp.app"
      ];
    };

    homeManager = {
      pkgs,
      lib,
      ...
    }: let
      extensions = import ./_extensions.nix;

      # Firefox's toolbar widget id for an extension's button.
      widgetId = id: builtins.replaceStrings ["@" "." "{" "}"] ["_" "_" "_" "_"] (lib.toLower id) + "-browser-action";
      extensionWidgets = map widgetId (builtins.attrNames extensions);
    in {
      # Default browser on Linux; on macOS it is picked in System Settings.
      xdg.mimeApps = lib.mkIf pkgs.stdenv.isLinux (let
        associations = lib.genAttrs [
          "text/html"
          "application/xhtml+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/about"
          "x-scheme-handler/unknown"
        ] (_: "floorp.desktop");
      in {
        enable = true;
        associations.added = associations;
        defaultApplications = associations;
      });
      home.sessionVariables = lib.mkIf pkgs.stdenv.isLinux {
        BROWSER = "floorp";
      };

      programs.floorp = {
        enable = true;
        package = lib.mkIf pkgs.stdenv.isDarwin null;
        # Policies reach the signed macOS app through defaults; ignored on Linux.
        darwinDefaultsId = "app.floorp.Floorp";

        policies = {
          DisableTelemetry = true;
          DisableAppUpdate = true;
          DisableFirefoxAccounts = true;
          # Bitwarden (in _extensions.nix) is the password manager.
          PasswordManagerEnabled = false;
          ExtensionSettings = extensions;
          # Sidebery reads these through storage.managed before its own storage.
          # _sidebery.json is its "Export addon data" output, settings and panels only.
          "3rdparty".Extensions."{3c078156-979c-498b-8990-85f7987dd929}" =
            lib.importJSON ./_sidebery.json;
        };

        # Sidebery is the tab bar, in the classic sidebar on the left.
        profiles.default = {
          settings =
            # macOS anchors the window buttons to the tab strip, which is hidden;
            # a native title bar gives them their own row.
            lib.optionalAttrs pkgs.stdenv.isDarwin {
              "browser.tabs.inTitlebar" = 0;
            }
            // {
              "sidebar.revamp" = false;
              "sidebar.verticalTabs" = false;
              "sidebar.position_start" = true;
              "floorp.panelSidebar.enabled" = false;
              "browser.toolbars.bookmarks.visibility" = "never";
              "floorp.design.configs" = builtins.toJSON (import ./_floorp-design.nix);
              # With the tab bar hidden, Lepton otherwise shows an empty menu bar
              # in fullscreen that squeezes the toolbar.
              "userChrome.hidden.titlebar_container" = true;

              # Toolbar: URL bar, then every extension button on the right.
              "browser.uiCustomization.state" = builtins.toJSON {
                placements = {
                  nav-bar = ["urlbar-container"] ++ extensionWidgets ++ ["unified-extensions-button"];
                  TabsToolbar = ["tabbrowser-tabs"];
                  vertical-tabs = [];
                  PersonalToolbar = ["personal-bookmarks"];
                  nora-statusbar = [];
                  unified-extensions-area = [];
                  widget-overflow-fixed-list = [];
                };
                # Widgets listed here are not re-added to their default spots.
                seen =
                  [
                    "reset-pbm-toolbar-button"
                    "smartwindow-group-tabs-button"
                    "ai-window-toggle"
                    "developer-button"
                    "ipprotection-button"
                    "profile-manager-button"
                    "undo-closed-tab"
                    "zen-mode-button"
                    "workspaces-toolbar-button"
                    "screenshot-button"
                  ]
                  ++ extensionWidgets;
                dirtyAreaCache = ["nav-bar" "TabsToolbar" "vertical-tabs" "PersonalToolbar" "nora-statusbar" "unified-extensions-area"];
                currentVersion = 28;
                newElementCount = 0;
              };
            };
        };
      };
    };
  };
}
