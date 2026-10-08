# i3 on a virtual X server (TigerVNC Xvnc), for headless machines such as
# OrbStack's. Connect from macOS Screen Sharing: `open vnc://<host>.orb.local:5901`.
{
  den.aspects.desktop.i3 = {
    nixos = {pkgs, ...}: {
      # Mesa software rendering: kitty needs OpenGL, there is no GPU here.
      hardware.graphics.enable = true;
      programs.dconf.enable = true;
      environment.systemPackages = [pkgs.tigervnc];
      networking.firewall.allowedTCPPorts = [5901];
    };

    homeManager = {
      pkgs,
      lib,
      config,
      ...
    }: let
      # Cmd (Super) with TigerVNC Viewer, which sends Option as Alt and Cmd as
      # Super. Option stays free for Emacs Meta, as on macOS. (macOS Screen
      # Sharing sends Cmd as Alt and Option+letter as ∂-style characters.)
      mod = "Mod4";

      # UI scale: 120 = 1.25x. TigerVNC on macOS isn't Retina-aware, so the
      # display stays 2560x1440 and only text/UI size changes. Xvnc reports it
      # to X clients; Xft.dpi covers GTK apps (Zen), kitty and i3.
      dpi = 120;

      block = name: runtimeInputs: text:
        lib.getExe (pkgs.writeShellApplication {
          name = "i3blocks-${name}";
          inherit runtimeInputs text;
        });

      session = pkgs.writeShellApplication {
        name = "i3-vnc-session";
        runtimeInputs = [pkgs.tigervnc pkgs.dbus pkgs.xrdb config.xsession.windowManager.i3.package];
        # -RawKeyboard: use the client's physical key codes instead of its
        # layout's characters, so TigerVNC's Option arrives as Alt (not ∂).
        text = ''
          Xvnc :1 -geometry 2560x1440 -depth 24 -dpi ${toString dpi} -rfbport 5901 -RawKeyboard=1 \
            -SecurityTypes VncAuth -rfbauth "$XDG_RUNTIME_DIR/vncpasswd" &
          while [ ! -e /tmp/.X11-unix/X1 ]; do sleep 0.1; done
          DISPLAY=:1 xrdb -merge ${config.home.homeDirectory}/.Xresources
          DISPLAY=:1 exec dbus-run-session i3
        '';
      };

      # macOS Screen Sharing doesn't share the clipboard with non-Apple VNC
      # servers. OrbStack's `mac` bridge runs pbcopy/pbpaste on the host, so
      # poll both clipboards and copy whichever side changed last.
      clipboardSync = pkgs.writeShellApplication {
        name = "clipboard-sync";
        runtimeInputs = [pkgs.xclip pkgs.coreutils];
        text = ''
          mac=/opt/orbstack-guest/bin/mac
          last="$XDG_RUNTIME_DIR/clipboard-sync.last"
          : > "$last"
          while sleep 1; do
            x=$(timeout 2 xclip -selection clipboard -o 2>/dev/null || true)
            m=$("$mac" pbpaste 2>/dev/null || true)
            prev=$(cat "$last")
            if [ -n "$x" ] && [ "$x" != "$prev" ]; then
              printf '%s' "$x" | "$mac" pbcopy
              printf '%s' "$x" > "$last"
            elif [ -n "$m" ] && [ "$m" != "$prev" ]; then
              printf '%s' "$m" | xclip -selection clipboard -i
              printf '%s' "$m" > "$last"
            fi
          done
        '';
      };
    in {
      sops.secrets.vncPassword = {};

      xresources.properties."Xft.dpi" = dpi;

      systemd.user.services.clipboard-sync = {
        Unit = {
          Description = "Sync the VNC display clipboard with the macOS host";
          After = ["i3-vnc.service"];
          BindsTo = ["i3-vnc.service"];
        };
        Service = {
          Environment = ["DISPLAY=:1"];
          ExecStart = lib.getExe clipboardSync;
          Restart = "always";
          RestartSec = 2;
        };
        Install.WantedBy = ["i3-vnc.service"];
      };

      systemd.user.services.i3-vnc = {
        Unit = {
          Description = "i3 on a TigerVNC virtual display";
          After = ["sops-nix.service"];
          Wants = ["sops-nix.service"];
        };
        Service = {
          Environment = ["LIBGL_ALWAYS_SOFTWARE=1"];
          ExecStartPre = toString (pkgs.writeShellScript "i3-vnc-passwd" ''
            ${pkgs.tigervnc}/bin/vncpasswd -f \
              < ${config.sops.secrets.vncPassword.path} \
              > "$XDG_RUNTIME_DIR/vncpasswd"
            chmod 600 "$XDG_RUNTIME_DIR/vncpasswd"
          '');
          ExecStart = lib.getExe session;
          Restart = "on-failure";
        };
        Install.WantedBy = ["default.target"];
      };

      home.packages = with pkgs; [dmenu xclip];

      xsession.windowManager.i3 = {
        enable = true;
        config = {
          modifier = mod;
          terminal = "kitty";
          menu = "dmenu_run";
          fonts = {
            names = ["JetBrainsMono Nerd Font"];
            size = 10.0;
          };
          # i3 reference card bindings, but with vim h/j/k/l instead of j/k/l/;
          # (on top of home-manager's arrow-key defaults). split h moves to g.
          keybindings = lib.mkOptionDefault {
            "${mod}+Return" = "exec kitty";
            "${mod}+d" = "exec dmenu_run";
            "${mod}+b" = "exec zen-twilight";

            "${mod}+h" = "focus left";
            "${mod}+j" = "focus down";
            "${mod}+k" = "focus up";
            "${mod}+l" = "focus right";

            "${mod}+Shift+h" = "move left";
            "${mod}+Shift+j" = "move down";
            "${mod}+Shift+k" = "move up";
            "${mod}+Shift+l" = "move right";

            "${mod}+g" = "split h";

            "${mod}+Shift+q" = "kill";
            "${mod}+Shift+c" = "reload";
            "${mod}+Shift+r" = "restart";
          };

          modes.resize = {
            "h" = "resize shrink width 10 px or 10 ppt";
            "j" = "resize grow height 10 px or 10 ppt";
            "k" = "resize shrink height 10 px or 10 ppt";
            "l" = "resize grow width 10 px or 10 ppt";
            "Left" = "resize shrink width 10 px or 10 ppt";
            "Down" = "resize grow height 10 px or 10 ppt";
            "Up" = "resize shrink height 10 px or 10 ppt";
            "Right" = "resize grow width 10 px or 10 ppt";
            "Escape" = "mode default";
            "Return" = "mode default";
            "${mod}+r" = "mode default";
          };
          # No borders or title bars; the focused window is the one with the cursor.
          window = {
            border = 0;
            titlebar = false;
          };
          floating = {
            border = 0;
            titlebar = false;
          };
          colors.focused = {
            border = "#d79921";
            background = "#d79921";
            text = "#282828";
            indicator = "#fabd2f";
            childBorder = "#d79921";
          };
          bars = [
            {
              position = "bottom";
              statusCommand = "${lib.getExe pkgs.i3blocks} -c ${config.xdg.configHome}/i3blocks/bottom";
              fonts = {
                names = ["JetBrainsMono Nerd Font"];
                size = 10.0;
              };
              colors = {
                background = "#282828";
                statusline = "#ebdbb2";
                separator = "#665c54";
              };
            }
          ];
        };
      };

      programs.i3blocks = {
        enable = true;
        bars.bottom = {
          load = {
            command = block "load" [pkgs.coreutils] ''
              read -r one _ < /proc/loadavg
              echo "load $one"
            '';
            interval = 5;
          };
          cpu = lib.hm.dag.entryAfter ["load"] {
            command = block "cpu" [pkgs.coreutils] ''
              read -r _ u1 n1 s1 i1 w1 _ < /proc/stat
              sleep 1
              read -r _ u2 n2 s2 i2 w2 _ < /proc/stat
              busy=$(( (u2 + n2 + s2) - (u1 + n1 + s1) ))
              total=$(( busy + (i2 + w2) - (i1 + w1) ))
              echo "cpu $(( total > 0 ? 100 * busy / total : 0 ))%"
            '';
            interval = 5;
          };
          memory = lib.hm.dag.entryAfter ["cpu"] {
            command = block "memory" [pkgs.procps pkgs.gawk] ''
              free -h | awk '/^Mem:/ { print "mem " $3 "/" $2 }'
            '';
            interval = 10;
          };
          disk = lib.hm.dag.entryAfter ["memory"] {
            command = block "disk" [pkgs.coreutils pkgs.gawk] ''
              df -h / | awk 'NR == 2 { print "disk " $3 "/" $2 }'
            '';
            interval = 60;
          };
          ip = lib.hm.dag.entryAfter ["disk"] {
            command = block "ip" [pkgs.iproute2 pkgs.gawk] ''
              ip -4 -o addr show eth0 | awk '{ split($4, a, "/"); print "ip " a[1] }'
            '';
            interval = 60;
          };
          time = lib.hm.dag.entryAfter ["ip"] {
            command = "${pkgs.coreutils}/bin/date '+%a %d %b %H:%M'";
            interval = 5;
          };
        };
      };
    };
  };
}
