{inputs, ...}: let
  extraSubstituters = [
    "https://cache.azizovich.uz?priority=4"
    "https://cache.xinux.uz?priority=3"
    "https://cache.nixos.org?priority=3"
    "https://nix-community.cachix.org?priority=2"
    "https://numtide.cachix.org?priority=2"
    "https://mirror.sjtu.edu.cn/nix-channels/store?priority=1"
    "https://mirrors.ustc.edu.cn/nix-channels/store?priority=1"
  ];

  extraTrustedPublicKeys = [
    "homelab:stmm75iPNqYy+lKg2QFvUaNcGirNCUk1ssB6nVttvZ4="
    "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
in {
  den.aspects.development.nix = {
    darwin = {config, ...}: {
      imports = [inputs.determinate.darwinModules.default];

      # Root-owned secret, read by determinate-nixd
      sops.secrets.atticNetrc = {
        path = "/etc/nix/attic.netrc";
        mode = "0400";
      };

      determinateNix = {
        enable = true;
        customSettings = {
          extra-substituters = extraSubstituters;
          extra-trusted-public-keys = extraTrustedPublicKeys;
          connect-timeout = 5;
        };
        determinateNixd.authentication.additionalNetrcSources = [
          config.sops.secrets.atticNetrc.path
        ];
      };
    };

    nixos = {
      nix = {
        enable = true;

        nixPath = [
          "nixpkgs=flake:nixpkgs"
        ];

        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
          ];
          substituters = extraSubstituters;
          trusted-public-keys = extraTrustedPublicKeys;
        };
      };
    };

    os = {
      nixpkgs = {
        config = {
          allowUnfree = true;
          allowBroken = false;
          allowInsecure = false;
          allowUnsupportedSystem = false;
        };
      };
    };

    homeManager = {
      pkgs,
      lib,
      config,
      ...
    }: {
      sops = {
        secrets.githubToken = {};
        templates."nix/nix.conf".content = ''
          access-tokens = github.com=${config.sops.placeholder.githubToken}
        '';
      };

      nix = {
        # NixOS' home-manager module already sets this from the system nix
        package = lib.mkDefault pkgs.nix;
        extraOptions = ''
          !include ${config.sops.templates."nix/nix.conf".path}
        '';
      };
    };
  };
}
