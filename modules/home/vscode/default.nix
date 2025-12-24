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
            pkief.material-product-icons
            jnoortheen.nix-ide
            mkhl.direnv
            golang.go
            haskell.haskell
            justusadam.language-haskell
            ms-python.python
            wakatime.vscode-wakatime
            timonwong.shellcheck
            usernamehw.errorlens
            oderwat.indent-rainbow
            bierner.markdown-mermaid
            christian-kohler.path-intellisense
            james-yu.latex-workshop
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "vscode-ide";
              publisher = "tlaplus";
              version = "2025.10.210006";
              sha256 = "sha256-xFFyxTNwv1/Qb9F/8x0UN4WUKQrZdoCDb5b89pDJ5W0=";
            }
            {
              name = "vscode-leetcode";
              publisher = "leetcode";
              version = "0.18.4";
              sha256 = "sha256-iiGK+XmTf9ROaSIksd71AHEJtatipebxmXI4v5r9nP8=";
            }
            {
              name = "inline-sql-syntax";
              publisher = "qufiwefefwoyn";
              version = "2.16.0";
              sha256 = "sha256-QAbYWwA6xlRfyqA/JBEUlxVt9q7RGbm0bLBkb4szYcA=";
            }
            {
              name = "markdown-checkbox";
              publisher = "bierner";
              version = "0.4.0";
              sha256 = "AoPcdN/67WOzarnF+GIx/nans38Jan8Z5D0StBWIbkk=";
            }
            {
              name = "lean4";
              publisher = "leanprover";
              version = "0.0.178";
              sha256 = "ByhiTGwlQgNkFf0BirO+QSDiXbQfR6RLQA8jM4B1+O4=";
            }
            {
              name = "markdown-preview-github-styles";
              publisher = "bierner";
              version = "2.0.3";
              sha256 = "yuF6TJSv0V2OvkBwqwAQKRcHCAXNL+NW8Q3s+dMFnLY=";
            }
            {
              name = "markdowntable";
              publisher = "takumii";
              version = "0.11.0";
              sha256 = "kn5aLRaxxacQMvtTp20IdTuiuc6xNU3QO2XbXnzSf7o=";
            }
            {
              name = "vscode-base64";
              publisher = "adamhartford";
              version = "0.1.0";
              sha256 = "ML3linlHH/GnsoxDHa0/6R7EEh27rjMp0PcNWDmB8Qw=";
            }
            {
              name = "vscode-containers";
              publisher = "ms-azuretools";
              version = "2.3.0";
              sha256 = "sha256-zrEZpd2geX2G4u6LkIk3d6C7vhwZZ4lwHGQR3Z0OWY4=";
            }
          ];

        userSettings = builtins.fromJSON (builtins.readFile ./json/settings.json);
        keybindings = builtins.fromJSON (builtins.readFile ./json/keybindings.json);
      };
    };
  };
}
