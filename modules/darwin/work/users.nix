{
  lib,
  inputs,
  outputs,
  ...
}: {
  config = {
    users.users = {
      abdivasiyev = {
        home = "/Users/abdivasiyev";

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

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users = {
        abdivasiyev = import ../../../darwin/work/home.nix;
      };

      extraSpecialArgs = {
        inherit inputs outputs;
      };
    };
  };
}
