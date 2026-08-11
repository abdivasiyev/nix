(self: super: {
  kubectl-readonly = super.buildGoModule (finalAttributes: {
    pname = "kubectl-readonly";
    version = "0.5.1";

    src = super.fetchFromGitHub {
      owner = "Evaneos";
      repo = "kubectl-readonly";
      tag = "v${finalAttributes.version}";
      hash = "sha256-sqfJH3NwOG4PAudYlWOY02+ejl/+vFsUCODLsAz7QSs=";
    };

    vendorHash = null;

    meta = {
      description = "";
      homepage = "https://github.com/Evaneos/kubectl-readonly";
      license = super.lib.licenses.mit;
    };
  });
})
