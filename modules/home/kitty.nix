{...}: {
  programs.kitty = {
    enable = true;
    shellIntegration = {
      enableZshIntegration = true;
    };
    font = {
      name = "JetBrains Mono";
      size = 15;
    };
    themeFile = "gruvbox-dark";
  };
}
