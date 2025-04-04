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
        "whisky"
        "obs"
        "ccleaner"
        "crystalfetch" # windows iso fetcher for mac
        "android-studio"
      ];
    };
  };
}
