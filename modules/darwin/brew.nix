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
      casks = [
        "tunnelblick"
        "jetbrains-toolbox"
        "lens"
        "redis-insight"
      ];
      brews = [
        "mas"
      ];
      masApps = {
        "SSTP Connect" = 1543667909;
      };
    };
  };
}
