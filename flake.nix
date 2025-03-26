{
  description = "My nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

	nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, home-manager, nixpkgs }:
  {
	  darwinConfigurations = {
		  personal = nix-darwin.lib.darwinSystem {
			  modules = [
				./darwin/personal/configuration.nix
				home-manager.darwinModules.home-manager
				{
					users.users.abdivasiyev.home = "/Users/abdivasiyev";
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.abdivasiyev = import ./darwin/personal/home.nix;
					};
				}
				nix-homebrew.darwinModules.nix-homebrew
				{
					nix-homebrew = {
						enable = true;
						enableRosetta = true;
						user = "abdivasiyev";
						autoMigrate = true;
					};
				}
			  ];
			  specialArgs = { inherit inputs; };
		  };
	  };
  };
}
