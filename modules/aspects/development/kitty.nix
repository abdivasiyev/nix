{
  den.aspects.development.kitty = {
    darwin = {pkgs, ...}: {
      system.defaults.dock.persistent-apps = [
        "${pkgs.kitty}/Applications/kitty.app"
      ];
    };

    homeManager = {pkgs, ...}: {
      # terminal emulator
      programs.kitty = {
        enable = true;
        package = pkgs.kitty;

        shellIntegration = {
          enableZshIntegration = true;
        };

        enableGitIntegration = false;

        font = {
          name = "JetBrains Mono";
          size = 15;
        };

        themeFile = "gruvbox-dark";
      };

      # terminal prompt
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          add_newline = true;
          character = {
            success_symbol = "[λ](bold green)";
            error_symbol = "[λ](bold red)";
          };
          status = {
            disabled = false;
            map_symbol = true;
          };
          sudo = {
            disabled = false;
          };
          direnv = {
            disabled = false;
          };
          git_metrics = {
            disabled = false;
          };
          localip = {
            disabled = false;
          };
        };
      };
    };
  };
}
