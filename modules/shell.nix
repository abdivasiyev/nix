{
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        alejandra
        nil
        deadnix
        statix
        git
        sops
      ];

      shellHook = ''
        echo "my nix configurations"
      '';
    };
  };
}
