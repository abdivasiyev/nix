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
        "jetbrains-toolbox"
        "redis-insight"
        "macs-fan-control"
        "telegram-desktop"
        "utm"
        "vlc"
        "emacs-app"
        "zen"
        "claude-code"
      ];
      brews = [
        "mas"
        "libvterm"
        "coreutils"
      ];
      masApps = {
      };
    };
  };
}
