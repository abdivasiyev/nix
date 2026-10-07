{...}: {
  den.aspects.chat.discord = {
    darwin.homebrew.casks = ["discord"];
    darwin.system.defaults.dock.persistent-apps = [
      "/Applications/Discord.app"
    ];
  };
}
