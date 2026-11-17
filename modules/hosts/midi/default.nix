{
  inputs,
  den,
  ...
}: {
  den.hosts.aarch64-linux.midi = {
    users.abdivasiyev = {};
    instantiate = inputs.nixpkgs-nixos.lib.nixosSystem;
  };

  den.aspects.midi = {
    includes = [
      den.aspects.profiles.linux
    ];

    nixos.imports = [./_utm/configuration.nix];
  };
}
