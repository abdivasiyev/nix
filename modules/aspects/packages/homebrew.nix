{
  den.aspects.packages.homebrew = {
    nix-homebrew = {
      enable = true;
      enableRosetta = true;
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
      taps = [
      ];
      casks = [
        "jetbrains-toolbox"
        "redis-insight"
        "macs-fan-control"
        "telegram-desktop"
        "vlc"
        "betterdisplay"
        "bruno"
        "discord"
        "orbstack"
        "element"
        "bitwarden"
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
