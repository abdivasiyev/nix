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
            asvetliakov.vscode-neovim
            golang.go
            haskell.haskell
            justusadam.language-haskell
            ms-python.python
            wakatime.vscode-wakatime
            timonwong.shellcheck
            usernamehw.errorlens
          ]
          ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          ];

        userSettings = builtins.fromJSON (builtins.readFile ./json/settings.json);
      };
    };
  };
}
