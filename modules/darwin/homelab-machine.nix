# Start the homelab machine once the disk it needs is actually there.
#
# OrbStack restores whichever machines were running when it last stopped, and
# it tries once -- about a minute after login. The homelab's bind mounts come
# from an external disk, and an external disk is not always mounted by then.
#
# On 22 September the Mac came back from a power cut on its own at 12:17,
# OrbStack asked for the machine at 12:18, and got:
#
#   configure LXC: bind /Volumes/Asliddin/Media -> /mnt/media:
#     no such file or directory
#
# It did not try again. The homelab stayed down for the next six and a half
# hours -- and because this Mac is also the home network's DNS server, every
# device in the house looked like it had lost the internet.
#
# So: wait for the paths the machine actually needs, then start it if it is
# not already running.
#
# Deliberately once, at boot, rather than on a timer. The failure being fixed
# is a race at startup, and a machine stopped by hand afterwards should stay
# stopped -- a daemon that restarted it every minute would be worse than the
# problem. Waiting is open-ended rather than a fixed number of retries,
# because a disk plugged in an hour late should still work; `timeout` only
# stops it waiting forever on a disk that is never coming.
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.homelab.machine;
  user = config.system.primaryUser;
  home = config.users.users.${user}.home;
  orb = "/Applications/OrbStack.app/Contents/MacOS/bin/orb";

  start = pkgs.writeShellApplication {
    name = "homelab-machine-start";
    runtimeInputs = [pkgs.coreutils];
    text = ''
      machine=${lib.escapeShellArg cfg.name}
      deadline=$(( $(date +%s) + ${toString cfg.timeout} ))

      # OrbStack runs as the person who logged in, not as root, so everything
      # here goes through them -- with HOME set, because that is where the
      # socket it talks to lives.
      orb() { /usr/bin/sudo -u ${lib.escapeShellArg user} \
                /usr/bin/env HOME=${lib.escapeShellArg home} ${orb} "$@"; }

      expired() {
        [ "$(date +%s)" -gt "$deadline" ]
      }

      for path in ${lib.escapeShellArgs cfg.requires}; do
        while [ ! -e "$path" ]; do
          if expired; then
            echo "giving up: $path never appeared; $machine not started" >&2
            exit 0
          fi
          sleep 5
        done
        echo "have $path" >&2
      done

      # OrbStack itself only starts when someone logs in, so this daemon is
      # normally here first.
      while ! orb list >/dev/null 2>&1; do
        if expired; then
          echo "giving up: OrbStack never answered; $machine not started" >&2
          exit 0
        fi
        sleep 5
      done

      state=$(orb list 2>/dev/null | awk -v m="$machine" '$1 == m { print $2 }')
      if [ "$state" = running ]; then
        echo "$machine is already running; nothing to do" >&2
        exit 0
      fi
      if [ -z "$state" ]; then
        echo "OrbStack does not know a machine called $machine" >&2
        exit 1
      fi

      echo "$machine is $state; starting it" >&2
      if orb start "$machine"; then
        echo "$machine started" >&2
      else
        echo "could not start $machine" >&2
        exit 1
      fi
    '';
  };
in {
  options.homelab.machine = {
    enable = lib.mkEnableOption "starting the homelab OrbStack machine once its disk is mounted";

    name = lib.mkOption {
      type = lib.types.str;
      default = "homelab";
      description = "The OrbStack machine to start.";
    };

    requires = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["/Volumes/Disk/Media"];
      description = ''
        Paths that must exist before the machine is started -- the host side
        of its bind mounts. A missing one is what makes OrbStack's own restore
        fail, and it fails the whole machine rather than the single mount.
      '';
    };

    timeout = lib.mkOption {
      type = lib.types.int;
      default = 1800;
      description = ''
        How long to keep waiting, in seconds. Generous on purpose: the cost of
        waiting is a sleeping shell, and the cost of giving up early is the
        homelab being down until somebody notices.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    launchd.daemons.homelab-machine = {
      # `script`, not ProgramArguments = [store path]: nix-darwin wraps the
      # former in `/bin/wait4path /nix/store && exec ...`, and without that a
      # daemon whose program lives on the /nix volume loses the race against
      # its mount at boot, dies with EX_CONFIG and is never retried. That is
      # how the homelab-lan daemons went missing on 21 September. A daemon
      # that only runs at boot cannot afford to lose that race.
      script = "exec ${lib.getExe start}";
      serviceConfig = {
        RunAtLoad = true;
        StandardOutPath = "/var/log/homelab-machine.log";
        StandardErrorPath = "/var/log/homelab-machine.log";
      };
    };

    environment.systemPackages = [start];
  };
}
