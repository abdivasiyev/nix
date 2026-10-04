{
  inputs,
  ...
}:
{
  den.aspects.secrets.sops = {
    # homeManager = {
    #   imports = [ inputs.sops-nix.darwinModules.sops ];

    #   sops = {
    #     age.keyFile = "/Users/abdivasiyev/.config/sops/age/keys.txt";
    #     # Only the age key: macOS has no /etc/ssh host keys, which sops-nix
    #     # would otherwise try (and fail on) for both gnupg and age.
    #     age.sshKeyPaths = [ ];
    #     gnupg.sshKeyPaths = [ ];
    #   };

    # };
    # flake-file.inputs = {
    #   sops-nix = {
    #     url = "github:Mic92/sops-nix";
    #     inputs.nixpkgs.follows = "nixpkgs";
    #   };
    # };
  };
}
