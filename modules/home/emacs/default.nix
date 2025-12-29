{pkgs, ...}: let
in {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };
}
