# The homelab's private Nix binary cache (Attic) at cache.azizovich.uz.
#
# Determinate Nix owns /etc/nix/nix.conf and its netrc, so the cache is added
# through Determinate's own nix-darwin module: the substituter and its key go
# to nix.custom.conf, and the access token is merged in by determinate-nixd
# from an extra netrc file (additionalNetrcSources).
#
# The token lives in secrets/secrets.yaml as `atticNetrc`, a netrc line:
#   machine cache.azizovich.uz password <token>
# made on the homelab with
#   sudo atticd-atticadm make-token --sub <machine> --validity 1y --pull homelab
# Until that key exists the cache is configured but unused (Nix falls back to
# cache.nixos.org on the 401).
{
  config,
  lib,
  inputs,
  ...
}: let
  secretsFile = ../../secrets/secrets.yaml;
  # sops keeps key names in plain text, so this can be checked at eval time
  # -- a declared secret missing from the file would fail the activation.
  hasToken = lib.hasInfix "\natticNetrc:" ("\n" + builtins.readFile secretsFile);
  # A real file, not the sops symlink: determinate-nixd refuses to start when
  # a netrc source is missing, and at boot it starts before sops decrypts.
  netrc = "/etc/nix/attic.netrc";
in {
  imports = [inputs.determinate.darwinModules.default];

  determinateNix = {
    enable = true;
    customSettings = {
      extra-substituters = ["https://cache.azizovich.uz/homelab"];
      extra-trusted-public-keys = ["homelab:stmm75iPNqYy+lKg2QFvUaNcGirNCUk1ssB6nVttvZ4="];
    };
    determinateNixd.authentication.additionalNetrcSources = [netrc];
  };

  # The installer's placeholder, replaced by the generated file.
  environment.etc."nix/nix.custom.conf".knownSha256Hashes = [
    "3bd68ef979a42070a44f8d82c205cfd8e8cca425d91253ec2c10a88179bb34aa"
  ];

  sops.secrets = lib.mkIf hasToken {
    atticNetrc.sopsFile = secretsFile;
  };

  system.activationScripts = {
    # Exists (empty is a valid netrc) before determinate-nixd reads its config.
    preActivation.text = ''
      [ -e ${netrc} ] || install -m 0600 -o root -g wheel /dev/null ${netrc}
    '';
    # After sops-nix has decrypted (its install script is mkAfter).
    postActivation.text = lib.mkOrder 2000 (lib.optionalString hasToken ''
      src=${config.sops.secrets.atticNetrc.path}
      if [ -s "$src" ] && ! cmp -s "$src" ${netrc}; then
        install -m 0600 -o root -g wheel "$src" ${netrc}
        echo "attic: cache token updated; restart determinate-nixd to use it:" >&2
        echo "  sudo launchctl kickstart -k system/systems.determinate.nix-daemon" >&2
      fi
    '');
  };
}
