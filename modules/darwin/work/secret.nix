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
  };
}
