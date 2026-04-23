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
        "tunnelblick"
        "jetbrains-toolbox"
        "lens"
        "redis-insight"
        "macs-fan-control"
        "telegram-desktop"
        "utm"
        "vlc"
        "emacs-app"
        "zen"
        "claude-code"
        "betterdisplay"
        "protonvpn"
      ];
      brews = [
        "mas"
        "libvterm"
        "coreutils"
        "gh"
      ];
      masApps = {
        "SSTP Connect" = 1543667909;
        "AWS Extend Switch Roles" = 1592710340;
      };
    };
  };
}
