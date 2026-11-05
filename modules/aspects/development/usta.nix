{inputs, ...}: {
  den.aspects.development.usta = {
    darwin = {config, ...}: {
      system.defaults.dock.persistent-apps = [
        "${config.users.users.abdivasiyev.home}/Applications/Home Manager Apps/usta.app"
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
          theme = "light";
          checkUpdates = false;
        };
      };
    };
  };

  flake-file.inputs.usta = {
    url = "github:abdivasiyev/usta/v0.1.0";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
