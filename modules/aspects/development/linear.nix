{
  den.aspects.development.linear = {
    darwin = {
      config,
      pkgs,
      ...
    }: {
      homebrew.casks = ["linear"];
      system.defaults.dock.persistent-apps = [
        "/Applications/Linear.app"
      ];
    };
  };
}
