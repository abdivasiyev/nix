# This Mac on the homelab's own VPN.
#
# The homelab runs Headscale -- a Tailscale control plane of its own -- so the
# node keys and the map of who may talk to whom stay in the house. This is the
# client half: nix-darwin's module runs `tailscaled` as a root launchd daemon,
# which on macOS creates a real utun interface rather than the userspace proxy
# you get when it runs unprivileged, so traffic routes transparently.
#
# Joining is one command, `homelab-vpn`, and is deliberately manual: a pre-auth
# key is a credential with a short life, and storing one in sops to save a
# single command each time a machine is rebuilt is a poor trade.
#
#   homelab-vpn                 # join, or re-join after a key expires
#   homelab-vpn --status        # where am I, and is it direct or relayed
#
# DNS is left alone on purpose. `overrideLocalDns` would point this Mac's only
# resolver at 100.100.100.100, and the home-network path (homelab-lan.nix)
# still owns resolution here. That changes when the migration reaches DNS, not
# before.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.homelab.vpn;
  tailscale = config.services.tailscale.package;

  join = pkgs.writeShellApplication {
    name = "homelab-vpn";
    runtimeInputs = [ tailscale ];
    text = ''
      server=${lib.escapeShellArg cfg.server}

      if [ "''${1:-}" = "--status" ]; then
        tailscale status || true
        echo
        # Which path a peer is actually using: "direct" means the carrier NAT
        # was punched through, "relay" means it is going via DERP.
        tailscale status --json 2>/dev/null |
          grep -E '"(CurAddr|Relay|HostName)"' | head -20 || true
        exit 0
      fi

      if ! tailscale status >/dev/null 2>&1; then
        echo "tailscaled is not answering; is services.tailscale enabled and switched?" >&2
      fi

      echo "joining $server"
      echo "a browser will open, or a URL will be printed -- approve the node there,"
      echo "or pass a pre-auth key: homelab-vpn --auth-key hskey-auth-..."
      exec sudo tailscale up --login-server "$server" --accept-dns=false "$@"
    '';
  };
in
{
  options.homelab.vpn = {
    enable = lib.mkEnableOption "joining the homelab's own VPN" // {
      default = true;
    };

    server = lib.mkOption {
      type = lib.types.str;
      default = "https://vpn.azizovich.uz";
      description = ''
        The homelab's Headscale control plane. Published through the Cloudflare
        tunnel and deliberately not behind Access -- a client able to complete
        the Access login would not need the VPN in the first place.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;
    environment.systemPackages = [ join ];
  };
}
