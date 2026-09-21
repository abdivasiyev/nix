# The user side of home-network access to the homelab (the system side,
# switching /etc/hosts, is modules/darwin/homelab-lan.nix):
#
#   * Git over SSH: at home, git-ssh.azizovich.uz already resolves to the Mac
#     mini, and this sends it straight to its SSH entrance (:22222) instead
#     of through cloudflared.
#
# There used to be a second half here: a client certificate imported into the
# login keychain, into each Zen profile's NSS database, trusted as a root and
# set as the identity preference for the domain -- because at home the
# homelab asked for one instead of a login. That is gone. The home site now
# asks Keycloak, the same as the tunnel does, so a browser needs nothing
# installed and a phone or an iPad can use the local route at all, which it
# never could.
{lib, ...}: {
  programs.ssh.matchBlocks."git-ssh-home" = lib.hm.dag.entryBefore ["git-ssh.azizovich.uz"] {
    match = ''host git-ssh.azizovich.uz exec "grep -q '^# home: ' /etc/hosts"'';
    port = 22222;
    proxyCommand = "none";
    # The same server as through the tunnel: keep one known_hosts entry.
    extraOptions.HostKeyAlias = "git-ssh.azizovich.uz";
  };
}
