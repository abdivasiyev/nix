{
  lib,
  den,
  ...
}: let
  user = "abdivasiyev";
  name = "Asliddin Abdivasiyev";
  email = "asliddin.abdivasiyev@gmail.com";
in {
  den.aspects.abdivasiyev = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "zsh")
    ];

    homeManager = {
      programs.git = {
        settings.user = {inherit name email;};
      };
    };

    os = {
      nix.settings.trusted-users = [user];
    };

    darwin = {
      system.primaryUser = user;

      users = {
        knownUsers = [user];
        users.${user} = {
          uid = 501;
          home = "/Users/${user}";
          isHidden = false;
          name = user;
          openssh.authorizedKeys.keys = lib.strings.splitString "\n" (
            builtins.readFile (
              builtins.fetchurl {
                url = "https://github.com/abdivasiyev.keys";
                sha256 = "059prm6zqhpafcqcv7jhbhvx3izb98nl24yk8lgh3533jgpxwm1r";
              }
            )
          );
        };
      };
    };

    # whenever I use x86_64 device
    nixos = {
      users.users.${user} = {
        isNormalUser = true;
        description = name;
        # start user services (e.g. the i3 VNC session) at boot
        linger = true;
        extraGroups = [
          "docker"
          "kvm"
        ];
        openssh.authorizedKeys.keys = lib.strings.splitString "\n" (
          builtins.readFile (
            builtins.fetchurl {
              url = "https://github.com/abdivasiyev.keys";
              sha256 = "059prm6zqhpafcqcv7jhbhvx3izb98nl24yk8lgh3533jgpxwm1r";
            }
          )
        );
      };
    };
  };
}
