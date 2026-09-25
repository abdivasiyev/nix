{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;

    shellIntegration = {
      enableZshIntegration = true;
    };

    enableGitIntegration = false;

    font = {
      name = "JetBrains Mono";
      size = 15;
    };

    themeFile = "gruvbox-dark";
  };
}
