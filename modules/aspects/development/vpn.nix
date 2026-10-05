{
  den.aspects.development.tunnelblick = {home, ...}: {
    darwin.homebrew.casks = ["tunnelblick"];
    homeManager = {config, ...}: {
      sops.secrets = {
        mobiTunnelblick = {
          path = "${home}/.config/tunnelblick/mobi.ovpn";
          mode = "0400";
        };
      };
    };
  };

  den.aspects.development.sstp = {home, ...}: {
    darwin.homebrew.masApps = {
      "SSTP Connect" = 1543667909;
    };
    homeManager = {config, ...}: {
      sops.secrets = {
        mobiVpn = {
          path = "${home}/.config/sstp/mobi.vpn";
          mode = "0400";
        };
      };
    };
  };
}
