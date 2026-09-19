# The homelab (an OrbStack NixOS machine on the Mac mini, its own repo) can be
# rebuilt from this config: `homelab-bootstrap` recreates the machine, deploys
# it and restores ~/Homelab/backups. The first terminal on a Mac without the
# machine asks once whether to do that now. See bootstrap.sh.
{
  pkgs,
  lib,
  ...
}: let
  bootstrap = pkgs.writeShellApplication {
    name = "homelab-bootstrap";
    # orbctl/orb come from OrbStack's own install, so the caller's PATH stays.
    runtimeInputs = with pkgs; [
      age
      coreutils
      findutils
      git
      gnugrep
      gnused
      just
      openssh
      sops
    ];
    text = builtins.readFile ./bootstrap.sh;
  };
  lanCert = pkgs.writeShellApplication {
    name = "homelab-lan-cert";
    runtimeInputs = with pkgs; [coreutils gnugrep jq openssl sops];
    text = builtins.readFile ./lan-cert.sh;
  };
in {
  home.packages = [bootstrap lanCert];

  # Cheap on every shell: two stat calls until the question has been settled.
  programs.zsh.initContent = lib.mkAfter ''
    if [[ -o interactive && ! -e ''${XDG_STATE_HOME:-$HOME/.local/state}/homelab-bootstrap/done \
          && ! -e ''${XDG_STATE_HOME:-$HOME/.local/state}/homelab-bootstrap/declined ]]; then
      ${lib.getExe bootstrap} --ask
    fi
  '';
}
