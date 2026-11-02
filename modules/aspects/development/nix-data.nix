{
  den.aspects.development.nix-data = {
    homeManager = {
      programs.nix-data = {
        enable = true;
        systemConfig = "/etc/nixos/configuration.nix";
        flake = "/home/abdivasiyev/Development/git.azizovich.uz/abdivasiyev/worktrees/nix/master/flake.nix";
        flakearg = "midi";
      };
    };
  };

  flake-file.inputs = {
    nix-data = {
      url = "github:xinux-org/nix-data";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
