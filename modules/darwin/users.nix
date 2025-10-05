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
              sha256 = "11a36wbnifix917gpdxca8hyya7sxxzq8ii3n8991wsll5kj656i";
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
