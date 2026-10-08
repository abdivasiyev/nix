{
  den.aspects.development.orbstack = {
    # TigerVNC Viewer for OrbStack machines with a VNC desktop (e.g. midi).
    # Unlike macOS Screen Sharing it sends Option as Alt and Cmd as Super,
    # so Emacs Meta (Option) and i3 (Cmd) both work inside the VM.
    darwin.homebrew.casks = ["orbstack" "tigervnc-viewer"];
    darwin.system.defaults.dock.persistent-apps = [
      "/Applications/OrbStack.app"
    ];
  };
}
