{den, ...}: {
  den.aspects.development.direnv = {
    includes = [
      den.aspects.overlays.direnv
    ];

    homeManager = {
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        silent = true;
        nix-direnv.enable = true;
      };
    };
  };
}
