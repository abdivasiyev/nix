{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-macport;
  };

  xdg.configFile."emacs/early-init.el".source = ./emacs.d/early-init.el;
  xdg.configFile."emacs/init.el".source = ./emacs.d/init.el;
}
