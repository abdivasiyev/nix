{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig = builtins.readFile ./tmux/tmux.conf;
    plugins = with pkgs; [
      tmuxPlugins.yank
      tmuxPlugins.resurrect
      tmuxPlugins.gruvbox
    ];
  };
}
