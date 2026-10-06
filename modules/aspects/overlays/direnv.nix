{
  den.aspects.overlays.direnv = {
    os.nixpkgs.overlays = [
      (self: super: {
        direnv = super.direnv.overrideAttrs (_: {
          doCheck = false;
        });
      })
    ];
  };
}
