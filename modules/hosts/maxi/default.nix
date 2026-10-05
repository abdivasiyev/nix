{den, ...}: {
  den.hosts.aarch64-darwin.maxi = {
    users.abdivasiyev = {};
  };

  den.aspects.maxi = {
    darwin = {
      homebrew = {
        enable = true;
        onActivation = {
          cleanup = "zap";
          autoUpdate = true;
          upgrade = true;
        };
      };
    };
    includes = [
      den.aspects.profiles.work
    ];
  };
}
