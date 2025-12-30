{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };

  home.file.".emacs.d".source = ./emacs.d;
}
