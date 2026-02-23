{...}: {
  config = {
    nix-homebrew = {
      enable = true;
      enableRosetta = true;
      user = "abdivasiyev";
      autoMigrate = true;
      enableZshIntegration = true;
    };

    homebrew = {
      enable = true;
      onActivation = {
        cleanup = "zap";
        autoUpdate = true;
        upgrade = true;
      };
      casks = [
        "tunnelblick"
        "jetbrains-toolbox"
        "lens"
        "redis-insight"
        "macs-fan-control"
        "telegram-desktop"
        "utm"
        "vlc"
        "emacs-app"
      ];
      brews = [
        "mas"
        "libvterm"
      ];
      masApps = {
        "SSTP Connect" = 1543667909;
        "AWS Extend Switch Roles" = 1592710340;
      };
    };
  };
}
