{inputs, ...}: {
  den.aspects.secrets.sops = {
    darwin = {config, ...}: {
      imports = [inputs.sops-nix.darwinModules.sops];

      sops = {
        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        # Only the age key: macOS has no /etc/ssh host keys, which sops-nix
        # would otherwise try (and fail on) for both gnupg and age.
        age.sshKeyPaths = [];
        gnupg.sshKeyPaths = [];
      };
    };

    homeManager = {config, ...}: {
      imports = [inputs.sops-nix.homeManagerModules.sops];

      sops = {
        age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        # Only the age key: macOS has no /etc/ssh host keys, which sops-nix
        # would otherwise try (and fail on) for both gnupg and age.
        age.sshKeyPaths = [];
        gnupg.sshKeyPaths = [];
      };
    };

    os.home-manager.sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
    ];
  };
  flake-file.inputs = {
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
