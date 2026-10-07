# NixOS machine inside OrbStack, for building Linux-only projects.
# i3 runs on a virtual X server: `open vnc://midi.orb.local:5901`.
{
  inputs,
  den,
  ...
}: {
  den.hosts.aarch64-linux.midi = {
    users.abdivasiyev = {};
    # `nixpkgs` follows the -darwin branch; NixOS gets its own channel.
    instantiate = inputs.nixpkgs-nixos.lib.nixosSystem;
  };

  den.aspects.midi = {
    includes = [
      den.aspects.profiles.linux
    ];

    nixos.imports = [./_orbstack/configuration.nix];
  };
}
