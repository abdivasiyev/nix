{den, ...}: {
  den.aspects.profiles.personal = {
    includes = [
      den.aspects.packages.homebrew
      den.aspects.packages.system
      den.aspects.secrets.sops
      den.aspects.secrets.bitwarden
      den.aspects.editors.emacs
    ];
  };
}
