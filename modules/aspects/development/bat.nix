{
  den.aspects.development.bat = {
    homeManager = {pkgs, ...}: {
      programs.bat = {
        enable = true;
        package = pkgs.bat;
      };
    };
  };
}
