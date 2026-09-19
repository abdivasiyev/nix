{
  config,
  inputs,
  ...
}: let
  key = "${config.users.users.abdivasiyev.home}/.config/sops/age/keys.txt";
in {
  imports = [inputs.sops-nix.darwinModules.sops];

  sops = {
    age.keyFile = key;
    # Only the age key: macOS has no /etc/ssh host keys, which sops-nix
    # would otherwise try (and fail on) for both gnupg and age.
    age.sshKeyPaths = [];
    gnupg.sshKeyPaths = [];

    secrets = {
    };
  };
}
