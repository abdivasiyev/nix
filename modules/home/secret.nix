{
  pkgs,
  inputs,
  config,
  ...
}: let
  key = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
in {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = key;
    defaultSopsFile = ../../secrets.yaml;
  };
}
