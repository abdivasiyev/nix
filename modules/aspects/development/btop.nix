{
  den.aspects.development.btop = {
    homeManager = {pkgs, ...}: {
      programs.btop = {
        enable = true;
        package = pkgs.btop;
        settings = {
          vim_keys = true;
          rounded_corners = false;
        };
      };
    };
  };
}
