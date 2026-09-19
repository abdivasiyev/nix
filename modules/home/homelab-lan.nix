# The user side of home-network access to the homelab (the system side,
# switching /etc/hosts, is modules/darwin/homelab-lan.nix):
#
#   * Git over SSH: at home, git-ssh.azizovich.uz already resolves to the Mac
#     mini, and this sends it straight to its SSH entrance (:22222) instead
#     of through cloudflared.
#   * The client certificate the homelab asks for at home on apps that are
#     behind Cloudflare Access elsewhere: imported into the login keychain,
#     where Safari and Chrome find it. It lives in secrets/secrets.yaml as
#     `homelabLanClientP12` (made by `homelab-lan-cert`); until then this
#     does nothing.
{
  config,
  lib,
  ...
}: let
  secretsFile = ../../secrets/secrets.yaml;
  # sops keeps key names in plain text (see modules/darwin/cache.nix).
  hasCert = lib.hasInfix "\nhomelabLanClientP12:" ("\n" + builtins.readFile secretsFile);
  certName = "homelab client";
in {
  programs.ssh.matchBlocks."git-ssh-home" = lib.hm.dag.entryBefore ["git-ssh.azizovich.uz"] {
    match = ''host git-ssh.azizovich.uz exec "grep -q '^# home: ' /etc/hosts"'';
    port = 22222;
    proxyCommand = "none";
    # The same server as through the tunnel: keep one known_hosts entry.
    extraOptions.HostKeyAlias = "git-ssh.azizovich.uz";
  };

  sops.secrets = lib.mkIf hasCert {
    homelabLanClientP12.sopsFile = secretsFile;
  };

  home.activation.homelabLanClientCert = lib.mkIf hasCert (
    lib.hm.dag.entryAfter ["writeBoundary" "sops-nix"] ''
      p12=${config.sops.secrets.homelabLanClientP12.path}
      keychain="$HOME/Library/Keychains/login.keychain-db"
      if [ -s "$p12" ] && ! /usr/bin/security find-certificate -c ${lib.escapeShellArg certName} "$keychain" >/dev/null 2>&1; then
        tmp=$(mktemp)
        /usr/bin/base64 -d -i "$p12" -o "$tmp"
        # The bundle's password is not a secret (the bundle is, in sops);
        # macOS refuses to import one without a password.
        run /usr/bin/security import "$tmp" -k "$keychain" -f pkcs12 -P homelab \
          -T /Applications/Safari.app -T "/Applications/Google Chrome.app" || true
        rm -f "$tmp"
      fi
    ''
  );
}
