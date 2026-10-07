{
  den.aspects.development.tunnelblick = {
    darwin.homebrew.casks = ["tunnelblick"];
    darwin.system.defaults.dock.persistent-apps = [
      "/Applications/Tunnelblick.app"
    ];

    homeManager = {config, ...}: {
      sops.secrets = {
        mobiTunnelblick = {
          path = "${config.home.homeDirectory}/.config/tunnelblick/mobi.ovpn";
          mode = "0400";
        };
      };
    };
  };

  den.aspects.development.sstp = {
    darwin.homebrew.masApps = {
      "SSTP Connect" = 1543667909;
    };
    darwin.system.defaults.dock.persistent-apps = [
      "/Applications/SSTP Connect.app"
    ];
    homeManager = {config, ...}: {
      sops.secrets = {
        mobiVpn = {
          path = "${config.home.homeDirectory}/.config/sstp/mobi.vpn";
          mode = "0400";
        };
      };
    };
  };
}
