(self: super: {
  direnv = super.direnv.overrideAttrs (_: {
    doCheck = false;
  });
})
