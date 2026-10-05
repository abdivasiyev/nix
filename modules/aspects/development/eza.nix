{
  den.aspects.development.eza = {
    homeManager = {pkgs, ...}: {
      programs.eza = {
        enable = true;
        package = pkgs.eza;
        enableZshIntegration = true;
        colors = "always";
        git = true;
        icons = "always";
      };
    };
  };
}
