{
  lib,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  home-manager.users.abdivasiyev.programs.kitty.package = lib.mkForce (pkgs.symlinkJoin {
    name = "kitty";
    paths = [pkgs.kitty];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = "wrapProgram $out/bin/kitty --set LIBGL_ALWAYS_SOFTWARE 1";
  });

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Tashkent";

  users.users.abdivasiyev.extraGroups = ["video" "audio"];

  environment.systemPackages = [pkgs.docker-client];
  environment.variables.DOCKER_HOST = "ssh://abdivasiyev@192.168.64.1";

  services.qemuGuest.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  zramSwap.enable = true;

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
    ''
  ];

  system.stateVersion = "26.05";
}
