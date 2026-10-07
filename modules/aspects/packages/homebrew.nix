{inputs, ...}: {
  den.aspects.packages.homebrew = {user, ...}: {
    darwin = {
      imports = [
        (inputs.nix-homebrew.darwinModules.nix-homebrew or {})
      ];

      nix-homebrew = {
        user = user.name;
        enable = true;
        enableRosetta = true;
        mutableTaps = false;
      };
      homebrew = {
        enable = true;
        onActivation = {
          cleanup = "zap";
          autoUpdate = true;
          upgrade = true;
        };
        brews = [
          "mas"
          "coreutils"
          "mole"
        ];
      };
    };
  };

  flake-file.inputs.nix-homebrew.url = "github:zhaofengli/nix-homebrew";
}
