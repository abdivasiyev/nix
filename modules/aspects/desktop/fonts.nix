{
  den.aspects.desktop.fonts = {
    os = {pkgs, ...}: {
      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
      ];
    };

    nixos = {pkgs, ...}: {
      # kitty asks for plain "JetBrains Mono"; without it fontconfig falls back
      # to the proportional DejaVu Sans. The Nerd Font covers the icons.
      fonts.packages = [pkgs.jetbrains-mono];
      fonts.fontconfig.defaultFonts.monospace = [
        "JetBrains Mono"
        "JetBrainsMono Nerd Font"
      ];
    };
  };
}
