{
  description = "My nix system flake for darwin systems";

  inputs = {
    # If your configurations are only for darwin system
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    # if not
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";

    # Nix Darwin
    # Keep version same as your nixpkgs as much as possible
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    # Keep version same as nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix Homebrew repository
    # (suggested to remove, nix-darwin already supports it)
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Collection of fancy nix stuff
    # flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    ...
  } @ inputs: let
    # Self reference
    # For configurations
    outputs = self;

    # Temporary forEach implementation
    # If you want something fancy:
    # https://github.com/orzklv/nix/blob/master/flake.nix#L83-L96
    systems = [
      # Add more if you need
      "aarch64-darwin"
    ];

    # For every system... generate attributes...
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Project's preferred formatter
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Development environment
    devShells = forAllSystems (system: {
      default = import ./shell.nix {pkgs = nixpkgs.legacyPackages.${system};};
    });

    # Reusable darwin modules you might want to export
    # These are usually stuff you would upstream into nix-darwin
    darwinModules = import ./modules/darwin;

    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeModules = import ./modules/home;

    # Darwin configuration
    darwinConfigurations = {
      personal = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin/personal/configuration.nix
        ];
        specialArgs = {inherit inputs outputs;};
      };
    };
  };
}
