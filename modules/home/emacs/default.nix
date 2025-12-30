{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-macport;
  };

  home.file.".emacs.d/early-init.el".source = ./emacs.d/early-init.el;
  home.file.".emacs.d/init.el".source = ./emacs.d/init.el;
}
