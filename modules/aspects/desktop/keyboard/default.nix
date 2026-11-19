{
  den.aspects.desktop.keyboard = {
    darwin = {
      system.activationScripts.postActivation.text = ''
        echo "installing keyboard layouts..."
        rm -rf "/Library/Keyboard Layouts/ozbek.bundle"
        cp -R ${./ozbek.bundle} "/Library/Keyboard Layouts/ozbek.bundle"
        chmod -R u+w,go=rX "/Library/Keyboard Layouts/ozbek.bundle"
      '';

      system.defaults.CustomUserPreferences."com.apple.HIToolbox".AppleEnabledInputSources = [
        {
          InputSourceKind = "Keyboard Layout";
          "KeyboardLayout ID" = 252;
          "KeyboardLayout Name" = "ABC";
        }
        {
          InputSourceKind = "Keyboard Layout";
          "KeyboardLayout ID" = 19457;
          "KeyboardLayout Name" = "Russian - Phonetic";
        }
        {
          InputSourceKind = "Keyboard Layout";
          "KeyboardLayout ID" = -4578;
          "KeyboardLayout Name" = "Özbekça";
        }
        # the emoji/symbol viewer and press-and-hold accents.
        {
          "Bundle ID" = "com.apple.CharacterPaletteIM";
          InputSourceKind = "Non Keyboard Input Method";
        }
        {
          "Bundle ID" = "com.apple.PressAndHold";
          InputSourceKind = "Non Keyboard Input Method";
        }
      ];
    };
  };
}
