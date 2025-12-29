{pkgs, ...}: let
in {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
    extraConfig = builtins.concatStringsSep "\n" [
      (builtins.readFile ./elisp/init.lua)
    ];
  };
}
