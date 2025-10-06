{...}: {
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
}
