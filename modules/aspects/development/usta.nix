{inputs, ...}: {
  den.aspects.development.usta = {user, ...}: {
    darwin = {config, ...}: {
      system.defaults.dock.persistent-apps = [
        "/Users/${user.name}/Applications/Home Manager Apps/usta.app"
      ];
    };
    homeManager = {
      imports = [
        inputs.usta.homeManagerModules.default
      ];

      programs.usta = {
        enable = true;

        settings = {
          interval = "5m";
          theme = "system";
          checkUpdates = false;
        };
      };
    };
  };

  flake-file.inputs.usta = {
    url = "github:abdivasiyev/usta";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
