{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = true;
    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions;
          [
            jdinhlife.gruvbox
            eamodio.gitlens
            pkief.material-icon-theme
            jnoortheen.nix-ide
          ]
          ++ pkgs.vscode-utils. extensionsFromVscodeMarketplace [
          ];

        userSettings = {
          "[json]" = {
            "editor.defaultFormatter" = "vscode.json-language-features";
          };
          "extensions.autoCheckUpdates" = false;
          "workbench.colorTheme" = "Gruvbox Dark Hard";
          "github.copilot.nextEditSuggestions.enabled" = true;
          nix = {
            enableLanguageServer = true;
            serverPath = "nixd";
            serverSettings = {
              "nixd" = {
                "formatting" = {
                  "command" = ["alejandra" "--stdin"];
                };
              };
            };
          };
        };
      };
    };
  };
}
