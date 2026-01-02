{...}: {
  programs.git = {
    enable = true;
    difftastic = {
      enable = true;
      enableAsDifftool = true;
    };
    lfs.enable = true;
    userName = "Asliddin Abdivasiyev";
    userEmail = "asliddin.abdivasiyev@gmail.com";
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
}
