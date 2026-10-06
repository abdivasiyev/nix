{
  den.aspects.development.tmux = {
    homeManager = {pkgs, ...}: {
      programs.tmux = {
        enable = true;
        keyMode = "vi";
        terminal = "screen-256color";
        extraConfig = builtins.readFile ./conf/default.conf;
        plugins = with pkgs; [
          tmuxPlugins.yank
          tmuxPlugins.resurrect
          tmuxPlugins.gruvbox
        ];
      };
    };
  };
}
