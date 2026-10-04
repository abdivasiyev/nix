{ den, ... }: {
  den.hosts.aarch64-darwin.mini = {
    users.abdivasiyev = { };
  };

  den.aspects.mini = {
    includes = [
      den.aspects.profiles.personal
    ];
  };
}
