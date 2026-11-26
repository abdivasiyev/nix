{
  den.aspects.desktop.niri = {
    nixos = {pkgs, ...}: {
      programs.niri.enable = true;
      hardware.graphics.enable = true;

      services.greetd = {
        enable = true;
        settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
      };

      environment.systemPackages = with pkgs; [
        xwayland-satellite
        wl-clipboard
        wdisplays
      ];
    };

    homeManager = {
      lib,
      pkgs,
      ...
    }: let
      workspaces = lib.range 1 9;
      workspaceBinds =
        lib.concatMapStrings (n: ''
          Mod+${toString n} { focus-workspace ${toString n}; }
          Mod+Shift+${toString n} { move-column-to-workspace ${toString n}; }
        '')
        workspaces;
    in {
      xdg.configFile."niri/config.kdl".text = ''
        input {
            keyboard {
                xkb {
                    layout "us"
                }
            }
            mouse {
                natural-scroll
            }
            focus-follows-mouse
        }

        output "Virtual-1" {
            mode custom=true "3024x1890@60"
            scale 2
        }

        layer-rule {
            match namespace="^wallpaper$"
            place-within-backdrop true
        }

        prefer-no-csd

        hotkey-overlay {
            skip-at-startup
        }

        screenshot-path "~/Pictures/Screenshots/%Y-%m-%d %H-%M-%S.png"

        layout {
            background-color "transparent"
            gaps 8
            center-focused-column "never"
            default-column-width { proportion 0.5; }
            focus-ring {
                width 2
                active-color "#d79921"
                inactive-color "#504945"
            }
            border {
                off
            }
        }

        binds {
            Mod+Shift+Slash { show-hotkey-overlay; }

            Mod+Return { spawn "kitty"; }
            Mod+D { spawn "fuzzel"; }
            Mod+B { spawn "floorp"; }
            Mod+Shift+Q { close-window; }

            Mod+H { focus-column-left; }
            Mod+J { focus-window-or-workspace-down; }
            Mod+K { focus-window-or-workspace-up; }
            Mod+L { focus-column-right; }

            Mod+Shift+H { move-column-left; }
            Mod+Shift+J { move-window-down-or-to-workspace-down; }
            Mod+Shift+K { move-window-up-or-to-workspace-up; }
            Mod+Shift+L { move-column-right; }

            Mod+Comma { consume-window-into-column; }
            Mod+Period { expel-window-from-column; }

            Mod+R { switch-preset-column-width; }
            Mod+F { maximize-column; }
            Mod+Shift+F { fullscreen-window; }
            Mod+Minus { set-column-width "-10%"; }
            Mod+Equal { set-column-width "+10%"; }
            Mod+O { toggle-overview; }

        ${workspaceBinds}
            Print { screenshot; }
            Mod+Shift+E { quit; }
        }
      '';

      systemd.user.services.swaybg = {
        Unit = {
          PartOf = ["graphical-session.target"];
          After = ["graphical-session.target"];
          ConditionEnvironment = "WAYLAND_DISPLAY";
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.swaybg} -m fill -c '#282828' -i %h/Pictures/wallpaper";
          Restart = "on-failure";
        };
        Install.WantedBy = ["graphical-session.target"];
      };

      programs.fuzzel.enable = true;
      services.mako.enable = true;

      programs.waybar = {
        enable = true;
        systemd.enable = true;
        settings.main = {
          position = "bottom";
          modules-left = ["niri/workspaces"];
          modules-center = ["niri/window"];
          modules-right = ["cpu" "memory" "disk" "network" "clock"];
          cpu.format = "cpu {usage}%";
          memory.format = "mem {used:0.1f}G/{total:0.1f}G";
          disk.format = "disk {used}/{total}";
          network.format = "ip {ipaddr}";
          clock.format = "{:%a %d %b %H:%M}";
        };
      };
    };
  };
}
