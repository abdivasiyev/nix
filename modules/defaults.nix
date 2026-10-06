{
  inputs,
  outputs,
  lib,
  den,
  ...
}: {
  den.default.darwin.system.stateVersion = 7;
  den.default.darwin.imports = [
    (inputs.home-manager.darwinModules.home-manager or {})
  ];
  den.default.os.home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs outputs;
    };
  };
  den.default.homeManager = {
    imports = [
      #      (inputs.home-manager.homeModules.home-manager or {})
    ];
    # targets.darwin.copyApps.enable = true;
    # targets.darwin.linkApps.enable = false;

    home.stateVersion = "26.05";
  };
  den.default.includes = [
    den.batteries.inputs'
    den.batteries.self'
  ];
  den.schema.host.includes = [
    den.batteries.hostname
    den.batteries.host-aspects
  ];
  den.schema.user.classes = lib.mkDefault ["homeManager"];
  flake-file.inputs.self.submodules = true;
}
