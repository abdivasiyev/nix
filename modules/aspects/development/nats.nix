{
  den.aspects.development.nats = {
    os = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        natscli
      ];
    };
  };
}
