{...}: {
  config = {
    homebrew = {
      enable = true;
      user = "abdivasiyev";
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
        "betterdisplay"
        "blender"
        "protonvpn"
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
