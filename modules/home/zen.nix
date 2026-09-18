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
      };
    };

    profiles = {
      default = {
        extensionButtons = {
          "nav-bar" = [
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
            "{f209234a-76f0-4735-9920-eb62507a54cd}"
            "button@scholar.google.com"
            "{446900e4-71c2-419f-a6a7-df9c091e268b}"
            "{61a05c39-ad45-4086-946f-32adb0a40a9d}"
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

        search = {
          force = true;
          default = "google";
          privateDefault = "google";

          order = [
            "searxng"
            "marginalia"
            "google"
            "nixos-packages"
            "nixos-options"
            "hoogle"
            "go-symbols"
          ];

          engines = {
            searxng = {
              name = "SearXNG";
              urls = [
                {
                  template = "https://search.azizovich.uz/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconMapObj."16" = "https://search.azizovich.uz/favicon.ico";
              definedAliases = ["@s"];
            };

            marginalia = {
              name = "Marginalia";
              urls = [
                {
                  template = "https://marginalia-search.com/search";
                  params = [
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                    {
                      name = "ref";
                      value = "opensearch";
                    }
                  ];
                }
              ];
              iconMapObj."16" = "https://marginalia-search.com/favicon.ico";
              definedAliases = ["@m"];
            };

            hoogle = {
              name = "Hoogle";
              urls = [
                {
                  template = "https://hoogle.haskell.org/";
                  params = [
                    {
                      name = "hoogle";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              iconMapObj."16" = "https://hoogle.haskell.org/favicon.png";
              definedAliases = ["@h"];
            };

            nixos-packages = {
              name = "NixOS Packages";
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "channel";
                      value = "25.11";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };

            nixos-options = {
              name = "NixOS Options";
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "25.11";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@no"];
            };

            go-symbols = {
              name = "Go Symbols";
              urls = [
                {
                  template = "https://pkg.go.dev/search";
                  params = [
                    {
                      name = "q";
                      value = "{searchTerms}";
                    }
                    {
                      name = "m";
                      value = "symbol";
                    }
                  ];
                }
              ];
              iconMapObj."16" = "https://pkg.go.dev/static/shared/icon/favicon.ico";
              definedAliases = ["@go"];
            };

            # Built-in engines: keep Google, hide the rest
            google.metaData.alias = "@g";
            bing.metaData.hidden = true;
            ddg.metaData.hidden = true;
            ebay.metaData.hidden = true;
            # wikipedia.metaData.hidden = true;
            "amazondotcom-us".metaData.hidden = true;
          };
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
      };
    };
  };
}
