{...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      vp = "vi .";
      cat = "bat";
      top = "btop";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "golang"
        "docker"
        "docker-compose"
      ];
      theme = "robbyrussell";
    };
  };
}
