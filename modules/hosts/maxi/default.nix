{den, ...}: {
  den.hosts.aarch64-darwin.maxi = {
    users.abdivasiyev = {};
  };

  den.aspects.maxi = {
    includes = [
      den.aspects.profiles.work
    ];
  };
}
