{
  den.aspects.development.git = {
    darwin.homebrew.brews = ["gh"];

    homeManager = {
      pkgs,
      lib,
      ...
    }: let
      mkScript = name: file:
        pkgs.writeScriptBin name ''
          #!${pkgs.zsh}/bin/zsh
          export PATH=${lib.makeBinPath [pkgs.git pkgs.jq pkgs.curl]}:$PATH
          ${builtins.readFile file}
        '';
    in {
      home.packages = [
        (mkScript "git-wtclone" ./plugins/git-wtclone.zsh)
        (mkScript "git-wtadd" ./plugins/git-wtadd.zsh)
      ];

      programs.git = {
        enable = true;
        package = pkgs.git;
        lfs.enable = true;
        settings = {
          merge = {
            conflictStyle = "diff3";
          };
          credential."https://git.azizovich.uz" = {
            helper = ["" "rbw"];
            username = "abdivasiyev";
          };
          url."ssh://git@github.com/" = {
            insteadOf = "https://github.com/";
          };
          init.defaultBranch = "master";
          pull.rebase = true;
          rebase.autoStash = true;
          push.autoSetupRemote = true;

          alias = {
            wtc = "wtclone";
            wta = "wtadd";
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
    };
  };
}
