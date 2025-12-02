{...}: {
  programs.halloy = {
    enable = true;
    settings = {
      servers = {
        liberachat = {
          nickname = "abdivasiyev";
          server = "irc.libera.chat";
          channels = [
            "#postgresql"
            "#postgresql-lounge"
            "#postgresql-eu"
          ];
        };
      };
    };
  };
}
