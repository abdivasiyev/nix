{den, ...}: {
  den.hosts.aarch64-darwin.mini = {
    users.abdivasiyev = {};
  };

  den.aspects.mini = {
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
      den.aspects.profiles.personal
    ];
  };
}
