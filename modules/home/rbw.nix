{pkgs, ...}: {
  programs.rbw = {
    enable = true;

    settings = {
      email = "asliddin.abdivasiyev@gmail.com";
      base_url = "https://vault.azizovich.uz";
      lock_timeout = 28800; # 8h before it asks for the master password again
      pinentry = pkgs.pinentry_mac; # older home-manager wants the string "pinentry-mac"
    };
  };
}
