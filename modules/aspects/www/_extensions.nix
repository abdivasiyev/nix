# Firefox extensions shared by the Firefox-based browsers, as `ExtensionSettings`
# policy entries. The leading underscore keeps import-tree from loading it.
let
  extensions = {
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
    "{f209234a-76f0-4735-9920-eb62507a54cd}" = "unpaywall";
    "button@scholar.google.com" = "google-scholar-button";
    "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
    "{61a05c39-ad45-4086-946f-32adb0a40a9d}" = "linkding-extension";
    "{3c078156-979c-498b-8990-85f7987dd929}" = "sidebery";
    "addon@darkreader.org" = "darkreader";
  };
in
  builtins.mapAttrs (_: pluginId: {
    install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
    installation_mode = "force_installed";
  })
  extensions
