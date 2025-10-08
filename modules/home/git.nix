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
  };
}
