{
  config,
  inputs,
  ...
}: let
  key = "${config.users.users.abdivasiyev.home}/.config/sops/age/keys.txt";
in {
  imports = [inputs.sops-nix.darwinModules.sops];

  sops = {
    age.keyFile = key;

    secrets = {
      telegramApiId = {
        sopsFile = ../../../secrets/secrets.yaml;
        owner = "abdivasiyev";
        format = "yaml";
        path = "${config.users.users.abdivasiyev.home}/.config/telegram-teams-server/telegramApiId";
        mode = "0400";
      };
      telegramApiHash = {
        sopsFile = ../../../secrets/secrets.yaml;
        owner = "abdivasiyev";
        format = "yaml";
        path = "${config.users.users.abdivasiyev.home}/.config/telegram-teams-server/telegramApiHash";
        mode = "0400";
      };
      telegramBridgeWebhook = {
        sopsFile = ../../../secrets/secrets.yaml;
        owner = "abdivasiyev";
        format = "yaml";
        path = "${config.users.users.abdivasiyev.home}/.config/telegram-teams-server/telegramBridgeWebhook";
        mode = "0400";
      };
    };
  };
}
