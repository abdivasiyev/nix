{
  den.aspects.desktop.fonts = {
    os = {pkgs, ...}: {
      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
    };
  };
}
