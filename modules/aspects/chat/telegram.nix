{...}: {
  den.aspects.chat.telegram = {
    darwin.homebrew.casks = ["telegram-desktop"];
    darwin.system.defaults.dock.persistent-apps = [
      "/Applications/Telegram Desktop.app"
    ];
  };
}
