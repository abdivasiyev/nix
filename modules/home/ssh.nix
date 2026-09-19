{pkgs, ...}: {
  programs.ssh = {
    enable = true;
    # No home-manager defaults: only what is written here.
    enableDefaultConfig = false;

    # OrbStack's `orb` host for its Linux machines; must come before any Host
    # block. A missing file (no OrbStack on this Mac) is ignored by ssh.
    includes = ["~/.orbstack/ssh/config"];

    matchBlocks = {
      # Forgejo git-over-SSH through the Cloudflare tunnel.
      # Cloudflare proxies HTTP only, so the tunnel carries SSH as a WebSocket
      # over HTTPS and cloudflared unwraps it locally. Works from anywhere.
      # On the Mac mini, homelab.orb.local:2222 reaches the same server with
      # no proxy.
      "git-ssh.azizovich.uz" = {
        user = "forgejo";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        proxyCommand = "${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h";
      };
    };
  };
}
