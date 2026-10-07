{
  den.aspects.development.redis = {
    darwin.homebrew.casks = ["redis-insight"];
    darwin.system.defaults.dock.persistent-apps = [
      "/Applications/Redis Insight.app"
    ];
  };
}
