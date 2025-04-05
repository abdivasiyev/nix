{
  inputs,
  outputs,
  ...
}: {
  config = {
    users.users = {
      abdivasiyev = {
        home = "/Users/abdivasiyev";
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
