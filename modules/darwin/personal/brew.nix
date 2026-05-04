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
        "utm"
        "vlc"
        "emacs-app"
        "zen"
        "claude-code"
        "betterdisplay"
        "blender"
        "protonvpn"
        "bruno"
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
