{...}: {
  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableZshIntegration = true;
    };
    enableGitIntegration = true;
    font = {
      name = "JetBrains Mono";
      size = 15;
    };
    themeFile = "gruvbox_dark";
  };
}
