{pkgs, ...}: {
  services.emacs = {
    enable = true;
  };

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };
}
