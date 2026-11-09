{
  den.aspects.secrets.gpg = {
    homeManager = {
      pkgs,
      lib,
      ...
    }: {
      programs.gpg.enable = true; # manages ~/.gnupg/gpg.conf; the agent module needs it

      services.gpg-agent = {
        enable = true; # launchd agent on darwin, systemd on linux — handled by HM

        # darwin → pinentry-mac (already in systemPackages); linux hosts → GTK dialog
        pinentry.package =
          if pkgs.stdenv.isDarwin
          then pkgs.pinentry_mac
          else pkgs.pinentry-gnome3; # swap for pinentry-qt / pinentry-curses to taste

        defaultCacheTtl = 7200; # 2h: cache the passphrase after first unlock
        maxCacheTtl = 28800; # 8h hard ceiling

        # let Emacs (epg-pinentry-mode 'loopback) prompt in its own minibuffer
        extraConfig = ''
          allow-loopback-pinentry
        '';
      };
    };
  };
}
