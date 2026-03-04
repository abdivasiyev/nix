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
  imports = [inputs.zen-browser.homeModules.twilight];

  programs.zen-browser = {
    enable = true;

    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true;
      DisableMasterPasswordCreation = true;
      DisablePasswordReveal = true;
      DisableProfileImport = true;
      DisableRemoteImprovements = true;
      DisableSystemAddonUpdate = true;
      DisplayBookmarksToolbar = false;
      DisablePocket = true;
      DisableTelemetry = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      GenerativeAI = {
        Enabled = false;
      };
      ExtensionSettings = mkExtensionSettings {
        "aws-extend-switch-roles@toshi.tilfin.com" = "aws-extend-switch-roles3";
        "password-manager-firefox-extension@apple.com" = "icloud-passwords";
      };
    };

    profiles = {
      default = {
        id = 0;
        isDefault = true;
        settings = {
          zen.view.sidebar-expanded = false;
        };
      };
    };
  };
}
