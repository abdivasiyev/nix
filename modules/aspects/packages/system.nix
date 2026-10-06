{
  den.aspects.packages.system = {
    os = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        age
        sops
        inetutils
        jq
        ripgrep
        cloudflared
        glibtool
      ];
    };
  };
}
