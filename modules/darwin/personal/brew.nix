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
      user = "abdivasiyev";
      onActivation = {
        cleanup = "zap";
        autoUpdate = true;
        upgrade = true;
      };
      taps = [
      ];
      casks = [
        "jetbrains-toolbox"
        "redis-insight"
        "macs-fan-control"
        "telegram-desktop"
        "vlc"
        "emacs-app"
        "betterdisplay"
        "bruno"
        "discord"
        "claude"
        "orbstack"
        "ollama"
        "element"
      ];
      brews = [
        "mas"
        "libvterm"
        "coreutils"
        "gh"
        "mole"
      ];
      masApps = {
      };
    };
  };
}
