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
            asvetliakov.vscode-neovim
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
              name = "vscode-pull-request-github";
              publisher = "github";
              version = "0.120.2";
              sha256 = "sha256-XY98UQ2XuVhObfaRiVlwiV+thNH9biPN0aDYG1c7xrM=";
            }
          ];

        userSettings = builtins.fromJSON (builtins.readFile ./json/settings.json);
      };
    };
  };
}
