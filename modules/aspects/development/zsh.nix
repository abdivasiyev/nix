{
  den.aspects.development.zsh = {host, ...}: {
    homeManager = {
      pkgs,
      lib,
      config,
      ...
    }: {
      sops = {
        secrets.githubToken = {};
      };

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        shellAliases = {
          cat = "bat";
          top = "btop";
        };
        plugins = [
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.8.0";
              sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
            };
          }
        ];
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "vi-mode"
            "web-search"
            "timer"
            "nats"
            "docker"
            "docker-compose"
            "kubectl"
          ];
        };
        initContent = lib.mkMerge [
          (lib.mkAfter ''
            export GITHUB_TOKEN=$(cat ${config.sops.secrets.githubToken.path})
            source ${./git/plugins/shell.zsh}
          '')

          (lib.optionalString (host.class == "darwin") ''
            if [ -f /opt/homebrew/bin/brew ]; then
              eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
          '')
        ];
      };
    };
  };
}
