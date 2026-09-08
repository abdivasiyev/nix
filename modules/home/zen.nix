{inputs, pkgs, ...}: let
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

      ExtensionSettings = mkExtensionSettings {
        "password-manager-firefox-extension@apple.com" = "icloud-passwords";
        "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = "github-file-icons";
        "jid1-MnnxcxisBPnSXQ@jetpack" = "privacy-badger17";
        "addons@wakatime.com" = "wakatimes";
        "{c7632bd5-48ce-467d-9433-58f33477553d}" = "basic-json-formatter";
        "clearcache@michel.de.almeida" = "clearcache";
        "foxyproxy@eric.h.jung" = "foxyproxy-standard";
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
      };
    };
  };
}
