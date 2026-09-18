{
  pkgs,
  lib,
  ...
}: let
  # One implementation, two front ends: git discovers `git-*` executables on
  # PATH as subcommands, and the zsh functions wrap them to add the cd.
  mkScript = name: file:
    pkgs.writeScriptBin name ''
      #!${pkgs.zsh}/bin/zsh
      export PATH=${lib.makeBinPath [pkgs.git pkgs.jq pkgs.curl]}:$PATH
      ${builtins.readFile file}
    '';
in {
  home.packages = [
    (mkScript "git-wtclone" ./git-wtclone.zsh)
    (mkScript "git-wtadd" ./git-wtadd.zsh)
  ];

  programs.git.settings.alias = {
    wtc = "wtclone";
    wta = "wtadd";
  };
}
