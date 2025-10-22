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
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "vscode-ide";
              publisher = "tlaplus";
              version = "2025.10.210006";
              sha256 = "sha256-xFFyxTNwv1/Qb9F/8x0UN4WUKQrZdoCDb5b89pDJ5W0=";
            }
          ];

        userSettings = builtins.fromJSON (builtins.readFile ./json/settings.json);
      };
    };
  };
}
