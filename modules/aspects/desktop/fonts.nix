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
      # noto-fonts-color-emoji: starship's prompt symbols are emoji.
      fonts.packages = [pkgs.jetbrains-mono pkgs.noto-fonts-color-emoji];
      fonts.fontconfig.defaultFonts = {
        monospace = [
          "JetBrains Mono"
          "JetBrainsMono Nerd Font"
        ];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
