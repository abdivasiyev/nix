# Based on OrbStack's generated /etc/nixos/configuration.nix for the `midi`
# machine. incus.nix (hostname only) is dropped: the host sets it.
{
  lib,
  modulesPath,
  ...
}:

{
  imports =
    [
      # Include the default lxd configuration.
      "${modulesPath}/virtualisation/lxc-container.nix"
      # Include the OrbStack-specific configuration.
      ./orbstack.nix
    ];

  users.users.abdivasiyev = {
    # uid 501 matches the Mac user; NixOS refuses isNormalUser below 1000,
    # so override the user aspect's nixos block.
    isNormalUser = lib.mkForce false;
    uid = 501;
    extraGroups = [ "wheel" "orbstack" "audio" ];

    # simulate isNormalUser, but with an arbitrary UID
    isSystemUser = true;
    group = "users";
    createHome = true;
    home = "/home/abdivasiyev";
    homeMode = "700";
  };

  security.sudo.wheelNeedsPassword = false;

  # This being `true` leads to a few nasty bugs, change at your own risk!
  users.mutableUsers = false;

  time.timeZone = "Asia/Tashkent";

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
  };

  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  # Extra certificates from OrbStack.
  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
MIIBnDCCAUOgAwIBAgIUOvHYX4jL4rhB+GTaUhJiiWmYg5cwCgYIKoZIzj0EAwIw
HDEaMBgGA1UEAwwRaG9tZWxhYiBjbGllbnQgQ0EwHhcNMjYwOTE5MTczNDIzWhcN
MzYwOTE2MTczNDIzWjAcMRowGAYDVQQDDBFob21lbGFiIGNsaWVudCBDQTBZMBMG
ByqGSM49AgEGCCqGSM49AwEHA0IABEmYBv6lghgJXq2DtVX/e7FbgeET4u8eKK0b
YYh26AfWtPIKW0ilXlsvfBHRcCX9TxDhzO1/iDITFUzHXRf5XI2jYzBhMB0GA1Ud
DgQWBBQRm9LdYYRtams7pZe1MkrUPfK5uzAfBgNVHSMEGDAWgBQRm9LdYYRtams7
pZe1MkrUPfK5uzAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAKBggq
hkjOPQQDAgNHADBEAiBxTcSCBb2+Jesc8dxKUSwG+MnXD7iEkQ+C8vPPOLap6QIg
KB4C4ES8gzqSbE+crTsEXpdpA822MpjQwv2VxA/B9xM=
-----END CERTIFICATE-----

-----BEGIN CERTIFICATE-----
MIICDDCCAbKgAwIBAgIQVGDOVhophGLLWsWVACRdFDAKBggqhkjOPQQDAjBmMR0w
GwYDVQQKExRPcmJTdGFjayBEZXZlbG9wbWVudDEeMBwGA1UECwwVQ29udGFpbmVy
cyAmIFNlcnZpY2VzMSUwIwYDVQQDExxPcmJTdGFjayBEZXZlbG9wbWVudCBSb290
IENBMB4XDTI2MDcyOTA3MTIyOFoXDTM2MDcyOTA3MTIyOFowZjEdMBsGA1UEChMU
T3JiU3RhY2sgRGV2ZWxvcG1lbnQxHjAcBgNVBAsMFUNvbnRhaW5lcnMgJiBTZXJ2
aWNlczElMCMGA1UEAxMcT3JiU3RhY2sgRGV2ZWxvcG1lbnQgUm9vdCBDQTBZMBMG
ByqGSM49AgEGCCqGSM49AwEHA0IABIea2CttYNBBTfCFIan9Eq+8GRkwjfBtlF+A
9piArhsoGswkah2mBC14idd/P2eCzbF2+XhsSCtYsehVcE45ICujQjBAMA4GA1Ud
DwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBQDLSf/2iIF5aqM
DtylUfU76ci9QTAKBggqhkjOPQQDAgNIADBFAiEAxU2lGAkpQVDvk5PXE0fdwDT0
NbZ7touuE3GmBgCbs8kCIDIOtDyOo0Be8HhIaDRbYcgvNoRQHr9DdXEat7WshpvD
-----END CERTIFICATE-----

    ''
  ];

  # Version OrbStack installed this machine with. Never change it.
  system.stateVersion = "25.11";
}
