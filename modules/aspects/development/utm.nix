{
  den.aspects.development.utm = {user, ...}: {
    darwin = {config, ...}: {
      system.defaults.dock.persistent-apps = [
        "/Users/${user.name}/Applications/Home Manager Apps/UTM.app"
      ];
    };

    homeManager = {pkgs, ...}: {
      home.packages = [pkgs.utm];
    };
  };
}
