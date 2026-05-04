(self: super: {
  lima-full = super.lima-full.overrideAttrs (old: rec {
    version = "2.1.1";

    src = super.fetchFromGitHub {
      owner = "lima-vm";
      repo = "lima";
      rev = "v${version}";
      hash = "sha256-U054xA3utBcSfpyvsZi4MvgJGNa7QyAYJf9usNXpgXg=";
    };

    vendorHash = "sha256-C4YCuFVXkL5vS6lWZCGkEeZQgAkP55buPDGZ/wvMnAA=";

    meta = {
      knownVulnerabilities = [];
    };
  });
})
