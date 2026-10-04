{
  inputs,
  den,
  ...
}: {
  den.aspects.mini.includes = [(den.batteries.tty-autologin "abdivasiyev")];

  perSystem = {pkgs, ...}: {
    packages.vm = pkgs.writeShellApplication {
      name = "vm";
      text = let
        host = inputs.self.nixosConfigurations.mini.config;
      in ''
        ${host.system.build.vm}/bin/run-${host.networking.hostName}-vm "$@"
      '';
    };
  };
}
