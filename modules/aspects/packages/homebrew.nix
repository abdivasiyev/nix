{
  den.aspects.packages.homebrew = {
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
        "vlc"
        "betterdisplay"
        "bruno"
        "orbstack"
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
