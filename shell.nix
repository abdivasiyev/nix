{
  pkgs ? let
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
    import nixpkgs {overlays = [];},
  ...
}:
pkgs.stdenv.mkDerivation {
  name = "nix-dev";

  nativeBuildInputs = with pkgs; [
    # You know the drill
    git

    # Makefile, but better
    just

    # LSP Server
    nixd

    # Linter
    statix

    # Dead code checker
    deadnix

    # Formatter
    alejandra
  ];

  NIX_CONFIG = "extra-experimental-features = nix-command flakes";
}
