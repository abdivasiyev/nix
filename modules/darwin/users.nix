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
              sha256 = "03y3ns712p9c44d5bcdx37n2cg364y4jiy01m4dwx3kid1mhf63k";
            }
          )
        );
      };
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users = {
        abdivasiyev = import ../../darwin/personal/home.nix;
      };

      extraSpecialArgs = {
        inherit inputs outputs;
      };
    };
  };
}
