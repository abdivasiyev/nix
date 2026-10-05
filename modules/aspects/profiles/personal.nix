{den, ...}: {
  den.aspects.profiles.personal = {
    includes = [
      # global packages
      den.aspects.packages.homebrew
      den.aspects.packages.system

      # secret management
      den.aspects.secrets.sops
      den.aspects.secrets.bitwarden

      # editors
      den.aspects.editors.emacs

      # chat
      den.aspects.chat.telegram
      den.aspects.chat.discord
      den.aspects.chat.element
    ];
  };
}
