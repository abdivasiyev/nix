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
  pkgs,
  ...
}: let
  secretsFile = ../../secrets/secrets.yaml;
  # sops keeps key names in plain text (see modules/darwin/cache.nix).
  hasCert = lib.hasInfix "\nhomelabLanClientP12:" ("\n" + builtins.readFile secretsFile);
  certName = "homelab client";
  domain = "azizovich.uz";
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
      # The default keychain, whatever it is called on this Mac: hard-coding
      # login.keychain-db silently did nothing on one that has no such file.
      keychain=$(/usr/bin/security default-keychain | tr -d ' "')
      # sops-nix decrypts in a launchd agent it (re)starts just before; on a
      # first switch the file can lag behind this step by a few seconds.
      for _ in $(seq 1 20); do [ -s "$p12" ] && break; sleep 1; done
      # An identity (certificate *and* key), not a certificate by name:
      # `find-certificate -c` matches by prefix, so the CA ("homelab client
      # CA") counted as the certificate and the import never ran.
      if [ -s "$p12" ] && ! /usr/bin/security find-identity -v | grep -q '"${certName}"'; then
        tmp=$(mktemp)
        /usr/bin/base64 -d -i "$p12" -o "$tmp"
        # The bundle's password is not a secret (the bundle is, in sops);
        # macOS refuses to import one without a password.
        run /usr/bin/security import "$tmp" -k "$keychain" -f pkcs12 -P homelab \
          -T /Applications/Safari.app -T "/Applications/Google Chrome.app" || true
        rm -f "$tmp"
      fi
      # Zen (Firefox) keeps its own certificate store per profile.
      for db in "$HOME/Library/Application Support/zen/Profiles"/*/cert9.db; do
        [ -s "$p12" ] && [ -f "$db" ] || continue
        dir=$(dirname "$db")
        if ! ${pkgs.nss.tools}/bin/certutil -L -d "sql:$dir" 2>/dev/null | grep -q ${lib.escapeShellArg certName}; then
          tmp=$(mktemp)
          /usr/bin/base64 -d -i "$p12" -o "$tmp"
          run ${pkgs.nss.tools}/bin/pk12util -i "$tmp" -d "sql:$dir" -W homelab || true
          rm -f "$tmp"
        fi
      done
      # Safari only offers valid identities, and this one is signed by the
      # homelab's own CA: trust that CA in the login keychain (macOS asks
      # for the password once, the first time).
      if [ -s "$p12" ] && ! /usr/bin/security dump-trust-settings 2>/dev/null | grep -q 'homelab client CA'; then
        tmp=$(mktemp -d)
        /usr/bin/base64 -d -i "$p12" -o "$tmp/c.p12"
        ${pkgs.openssl}/bin/openssl pkcs12 -legacy -in "$tmp/c.p12" -passin pass:homelab -cacerts -nokeys 2>/dev/null \
          | ${pkgs.openssl}/bin/openssl x509 -out "$tmp/ca.pem"
        run /usr/bin/security add-trusted-cert -r trustRoot -p ssl -p basic -k "$keychain" "$tmp/ca.pem" || true
        rm -rf "$tmp"
      fi
      # Safari (and anything using the keychain) picks it without asking --
      # once the identity is actually there. A first switch can run before
      # sops-nix has written the bundle, and then there is nothing to prefer.
      if ! /usr/bin/security find-identity -v | grep -q '"${certName}"'; then
        echo "homelab: no client certificate in the keychain yet; switch again once sops has run" >&2
      else
      for service in ${lib.escapeShellArgs ["*.${domain}" domain]}; do
        if ! /usr/bin/security get-identity-preference -s "$service" -c 2>/dev/null | grep -q ${lib.escapeShellArg certName}; then
          run /usr/bin/security set-identity-preference -c ${lib.escapeShellArg certName} -s "$service" || true
        fi
      done
      fi
    ''
  );
}
