# At home, reach the homelab directly instead of through Cloudflare.
#
# A root daemon checks, on every network change and once a minute, whether
# the homelab answers on the home network: an HTTPS request to
# lan.azizovich.uz pinned to the Mac mini's address, with the certificate
# verified -- so a foreign network cannot pose as home. At home it writes
# every app's hostname into a marked block of /etc/hosts, pointing at the
# Mac mini; anywhere else it removes the block and DNS (Cloudflare) takes
# over again. The homelab publishes the hostname list itself (lan.nix in the
# homelab repo), so new apps need nothing here.
#
# On the Mac mini (`forward`), OrbStack keeps the homelab's ports on
# loopback; two forwarders open exactly the home entrances to the LAN:
# :443 (the homelab's home HTTPS site, 127.0.0.1:8443) and :22222 (Forgejo
# SSH). OrbStack's own "expose machine ports to LAN" stays off, so nothing
# else of the homelab is reachable from the network.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homelab.lan;
  begin = "# >>> homelab-lan (managed by nix-darwin; do not edit)";
  end = "# <<< homelab-lan";

  check = pkgs.writeShellApplication {
    name = "homelab-lan-check";
    runtimeInputs = with pkgs; [curl coreutils gnused gawk diffutils];
    text = ''
      server=${lib.escapeShellArg cfg.server}
      domain=${lib.escapeShellArg cfg.domain}
      ip=$server
      case $server in
        *.local)
          ip=$(/usr/bin/dscacheutil -q host -a name "$server" | awk '/^ip_address:/ { print $2; exit }')
          ;;
      esac

      block=""
      ask() { curl -fsS --max-time 3 --resolve "lan.$domain:443:$ip" "https://lan.$domain$1" 2>/dev/null; }
      if [ -n "$ip" ] && [ "$(ask /)" = homelab ] && hosts=$(ask /hosts); then
        block="${begin}
      # home: $ip
      $(printf '%s\n' "$hosts" git-ssh."$domain" | awk -v ip="$ip" 'NF { print ip, $1 }')
      ${end}"
      fi

      current=$(cat /etc/hosts)
      rest=$(printf '%s\n' "$current" | sed '/^${begin}$/,/^${end}$/d')
      if [ -n "$block" ]; then
        wanted=$(printf '%s\n%s\n' "$rest" "$block")
      else
        wanted=$rest
      fi
      if [ "$wanted" != "$current" ]; then
        printf '%s\n' "$wanted" > /etc/hosts.homelab-lan
        mv /etc/hosts.homelab-lan /etc/hosts
        /usr/bin/dscacheutil -flushcache
        /usr/bin/killall -HUP mDNSResponder 2>/dev/null || true
        if [ -n "$block" ]; then echo "home network: homelab at $ip"; else echo "away: through Cloudflare"; fi
      fi
    '';
  };

  forwarder = listen: target: {
    serviceConfig = {
      ProgramArguments = [
        (lib.getExe pkgs.socat)
        "TCP-LISTEN:${toString listen},fork,reuseaddr"
        "TCP:127.0.0.1:${toString target}"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      ThrottleInterval = 10;
    };
  };
in {
  options.homelab.lan = {
    server = lib.mkOption {
      type = lib.types.str;
      example = "Mac-mini.local";
      description = "Address of the Mac mini on the home network (a .local name is resolved over mDNS), or 127.0.0.1 on the Mac mini itself.";
    };
    domain = lib.mkOption {
      type = lib.types.str;
      default = "azizovich.uz";
    };
    forward = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "This Mac runs the homelab: open its home entrances (:443, :22222) to the LAN.";
    };
  };

  config = lib.mkMerge [
    {
      launchd.daemons.homelab-lan = {
        serviceConfig = {
          ProgramArguments = [(lib.getExe check)];
          RunAtLoad = true;
          StartInterval = 60;
          # Network changes rewrite these.
          WatchPaths = ["/etc/resolv.conf" "/Library/Preferences/SystemConfiguration/NetworkInterfaces.plist"];
          StandardOutPath = "/var/log/homelab-lan.log";
          StandardErrorPath = "/var/log/homelab-lan.log";
        };
      };
      environment.systemPackages = [check];
    }
    (lib.mkIf cfg.forward {
      launchd.daemons.homelab-lan-https = forwarder 443 8443;
      # OrbStack itself holds 127.0.0.1:2222, hence another port outside.
      launchd.daemons.homelab-lan-ssh = forwarder 22222 2222;

      # OrbStack would otherwise publish every port the homelab listens on to
      # the LAN, Access apps included; the forwarders above are the only
      # entrances. (Takes effect when OrbStack next starts.)
      system.activationScripts.postActivation.text = lib.mkAfter ''
        orbctl=/Applications/OrbStack.app/Contents/MacOS/bin/orbctl
        user=${lib.escapeShellArg config.system.primaryUser}
        if [ -x "$orbctl" ] && [ "$(sudo -u "$user" "$orbctl" config get machines.expose_ports_to_lan 2>/dev/null)" = true ]; then
          sudo -u "$user" "$orbctl" config set machines.expose_ports_to_lan false >/dev/null
          echo "homelab: OrbStack no longer exposes machine ports to the LAN; restart OrbStack to apply" >&2
        fi
      '';
    })
  ];
}
