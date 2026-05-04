{...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "Asliddin Abdivasiyev";
        email = "asliddin.abdivasiyev@gmail.com";
      };
    };
    ignores = [
      ".DS_Store"
      ".vscode/"
      "node_modules/"
      "dist/"
      "result/"
      "*.log"
      ".env"
      ".idea"
      "*.swp"
      "*~"
      "*#"
      ".#*"
    ];
  };

  programs.difftastic = {
    enable = true;
    git = {
      enable = true;
      diffToolMode = true;
    };
  };
}
