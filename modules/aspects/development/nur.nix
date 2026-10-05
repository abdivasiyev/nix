{inputs, ...}: {
  den.aspects.development.nur = {
    darwin.imports = [
      inputs.nur.modules.darwin.default
    ];

    homeManager.imports = [
      inputs.nur.modules.homeManager.default
    ];

    os.nixpkgs.overlays = [
      inputs.nur.overlays.default
    ];
  };

  flake-file.inputs.nur = {
    url = "github:nix-community/NUR";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
