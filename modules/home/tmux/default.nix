{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    extraConfig = builtins.readFile ./tmux/tmux.conf;
    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.resurrect
      {
        plugin = tmuxPlugins.rose-pine;
        extraConfig = builtins.readFile ./tmux/rose-pine.conf;
      }
    ];
  };
}
