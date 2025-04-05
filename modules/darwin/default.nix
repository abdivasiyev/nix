# Add your reusable Darwin modules to this directory, on their own file (https://wiki.nixos.org/ wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
#
# Refer to the link below for more options:
# https://ndw.xinux.uz/manual/stable/
{
  # List your module files here
  users = import ./users.nix;
  brew = import ./brew.nix;
  system = import ./system.nix;
}
