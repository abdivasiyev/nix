# Add your reusable home-manager modules to this directory, on their own file (https://wiki.nixos.org/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
#
# Refer to the link below for more options:
# https://nix-community.github.io/home-manager/options.xhtml
{
  # List your module files here
  alacritty = import ./alacritty.nix;
  bat = import ./bat.nix;
  carapace = import ./carapace.nix;
  eza = import ./eza.nix;
  git = import ./git.nix;
  go = import ./go.nix;
  nvim = import ./nvim;
  tmux = import ./tmux;
  zsh = import ./zsh.nix;
}
