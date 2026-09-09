{
  inputs,
  pkgs,
  ...
}: let
  mkExtensionSettings = builtins.mapAttrs (_: pluginId: {
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
    installation_mode = "force_installed";
  });
in {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
    darwin.packageMode = "signed";
    darwinDefaultsId = "app.zen-browser.zen";

    nativeMessagingHosts = [
      # pkgs.firefoxpwa
    ];

    policies = {
      DisableTelemetry = true;
      BlockAboutConfig = true;
      DisableAppUpdate = true;

      ExtensionSettings = mkExtensionSettings {
        "password-manager-firefox-extension@apple.com" = "icloud-passwords";
        "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons";
        "jid1-MnnxcxisBPnSXQ@jetpack" = "privacy-badger17";
        "addons@wakatime.com" = "wakatimes";
        "{c7632bd5-48ce-467d-9433-58f33477553d}" = "basic-json-formatter";
        "clearcache@michel.de.almeida" = "clearcache";
        "foxyproxy@eric.h.jung" = "foxyproxy-standard";
        "aws-extend-switch-roles@toshi.tilfin.com" = "aws-extend-switch-roles3";
        "jid0-dsq67mf5kjjhiiju2dfb6kk8dfw@jetpack" = "turbo-download-manager";
        "{d07ccf11-c0cd-4938-a265-2a4d6ad01189}" = "view-page-archive";
        "{a9c2ad37-e940-4892-8dce-cd73c6cbbc0c}" = "feedbroreader";
      };
    };

    profiles = {
      default = {
        extensionButtons = {
          "nav-bar" = [
            "password-manager-firefox-extension@apple.com"
            "{85860b32-02a8-431a-b2b1-40fbd64c9c69}"
            "jid1-MnnxcxisBPnSXQ@jetpack"
            "addons@wakatime.com"
            "{c7632bd5-48ce-467d-9433-58f33477553d}"
            "clearcache@michel.de.almeida"
            "foxyproxy@eric.h.jung"
            "aws-extend-switch-roles@toshi.tilfin.com"
            "jid0-dsq67mf5kjjhiiju2dfb6kk8dfw@jetpack"
            "{d07ccf11-c0cd-4938-a265-2a4d6ad01189}"
            "{a9c2ad37-e940-4892-8dce-cd73c6cbbc0c}"
          ];
        };

        settings = {
          "zen.workspaces.continue-where-left-off" = true;
          "zen.view.compact.hide-tabbar" = true;
          "zen.view.compact.enable-at-startup" = true;
          "zen.view.sidebar-expanded" = false;
          "zen.view.use-single-toolbar" = false;
          "zen.urlbar.behavior" = "float";
          "zen.welcome-screen.seen" = true;
        };

        presets = {
          catppuccin = {
            enable = true;
            flavor = "Mocha"; # Frappe | Latte | Macchiato | Mocha
            accent = "Mauve"; # Blue, Flamingo, Green, Lavender, Maroon, Mauve, ...
          };
        };

        mods = [
          "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar scrollbar
          "8039de3b-72e1-41ea-83b3-5077cf0f98d1" # Trackpad Animation
          "f4866f39-cfd6-4498-ab92-54213b8279dc" # Animations Plus+
        ];

        userChrome = ''
          /* Zen — minimal & clean. Keep the Catppuccin import as the FIRST line. */
          @import "catppuccin/userChrome.css";

          :root {
            /* Rounder, more inset web content.
               JS sets --zen-element-separation inline, so it needs !important.
               --zen-webview-border-radius is unset by Zen, so it wins cleanly. */
            --zen-element-separation: 12px !important;
            --zen-webview-border-radius: 14px;

            /* Kill the hairline border around the content area */
            --zen-appcontent-border: none;

            /* Softer float instead of a hard card edge */
            --zen-big-shadow: rgba(0, 0, 0, 0.16) 0px 4px 16px;
          }

          /* Toolbar buttons dimmed until hover */
          #nav-bar .toolbarbutton-1,
          #zen-appcontent-navbar-wrapper .toolbarbutton-1 {
            opacity: 0.68;
            transition: opacity 0.12s ease;
          }

          #nav-bar .toolbarbutton-1:hover,
          #nav-bar .toolbarbutton-1[open],
          #zen-appcontent-navbar-wrapper .toolbarbutton-1:hover,
          #zen-appcontent-navbar-wrapper .toolbarbutton-1[open] {
            opacity: 1;
          }

          /* No separator lines in the sidebar */
          #zen-sidebar-top-buttons-separator,
          .pinned-tabs-container-separator,
          #tabbrowser-tabs toolbarseparator {
            border: none !important;
            background: transparent !important;
            opacity: 0 !important;
          }

          /* Slimmer tab rows (Zen default is 46px when expanded) */
          #tabbrowser-tabs {
            --tab-min-height: 36px !important;
          }
        '';
      };
    };
  };
}
