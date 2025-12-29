# Add your reusable home-manager modules to this directory, on their own file (https://wiki.nixos.org/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
#
# Refer to the link below for more options:
# https://nix-community.github.io/home-manager/options.xhtml
{
  # List your module files here
  bat = import ./bat.nix;
  eza = import ./eza.nix;
  git = import ./git.nix;
  tmux = import ./tmux;
  zsh = import ./zsh.nix;
  kitty = import ./kitty.nix;
  secret = import ./secret.nix;
  vscode = import ./vscode;
  nvim = import ./nvim;
  starship = import ./starship.nix;
  halloy = import ./halloy.nix;
  emacs = import ./emacs;
}
