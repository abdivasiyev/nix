# Push every new store path of this Mac to the homelab's Attic cache, so a
# darwin package built or downloaded here is a download on the other Macs.
#
# The homelab runs in OrbStack on this machine, and OrbStack forwards the
# machine's localhost ports, so pushes go straight to atticd on
# 127.0.0.1:8095 -- no Cloudflare in between, no upload size limit.
#
# The token lives in secrets/secrets.yaml as `atticPushToken` (the bare
# token), made on the homelab with
#   sudo atticd-atticadm make-token --sub mac-mini --validity 1y \
#     --pull homelab --push homelab
# Until that key exists nothing is pushed.
{
  config,
  lib,
  pkgs,
  ...
}: let
  secretsFile = ../../secrets/secrets.yaml;
  # sops keeps key names in plain text (see cache.nix).
  hasToken = lib.hasInfix "\natticPushToken:" ("\n" + builtins.readFile secretsFile);
  state = "/var/lib/attic-watch-store";
  clientConfig = pkgs.writeText "attic-config.toml" ''
    default-server = "homelab"

    [servers.homelab]
    endpoint = "http://127.0.0.1:8095/"
    token-file = "${config.sops.secrets.atticPushToken.path}"
  '';
in {
  config = lib.mkIf hasToken {
    sops.secrets.atticPushToken.sopsFile = secretsFile;

    environment.systemPackages = [pkgs.attic-client];

    launchd.daemons.attic-watch-store = {
      script = ''
        # sops decrypts at boot in its own daemon, and OrbStack starts at
        # login; wait for both rather than fail.
        until [ -s ${config.sops.secrets.atticPushToken.path} ]; do sleep 5; done
        until /usr/bin/curl -s -o /dev/null http://127.0.0.1:8095/; do sleep 10; done
        /usr/bin/install -d -m 0700 ${state}/attic
        /usr/bin/install -m 0600 ${clientConfig} ${state}/attic/config.toml
        export XDG_CONFIG_HOME=${state}
        exec ${lib.getExe pkgs.attic-client} watch-store homelab:homelab
      '';
      serviceConfig = {
        RunAtLoad = true;
        KeepAlive = true;
        ThrottleInterval = 30;
        ProcessType = "Background";
        LowPriorityIO = true;
        Nice = 10;
        StandardOutPath = "/var/log/attic-watch-store.log";
        StandardErrorPath = "/var/log/attic-watch-store.log";
      };
    };
  };
}
