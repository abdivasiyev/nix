{...}: {
  den.aspects.editors.emacs = {user, ...}: {
    darwin = {config, ...}: {
      system.defaults.dock.persistent-apps = [
        "/Users/${user.name}/Applications/Home Manager Apps/Emacs.app"
      ];
      homebrew.brews = ["libvterm"];
    };

    homeManager = {
      pkgs,
      lib,
      config,
      ...
    }: let
      emacs =
        if pkgs.stdenv.isLinux
        then pkgs.emacs-pgtk
        else pkgs.emacs;
      emacsPackages = pkgs.emacsPackagesFor emacs;

      hpkgs = pkgs.haskell.packages."ghc912";

      migrate = pkgs.go-migrate.overrideAttrs (oldAttrs: {
        tags = ["postgres"];
      });

      gruber-darker-theme = emacsPackages.melpaBuild {
        pname = "gruber-darker-theme";
        version = "0.6";
        src = pkgs.fetchFromGitHub {
          owner = "rexim";
          repo = "gruber-darker-theme";
          rev = "v0.6";
          hash = "sha256-9LcKIOwxUp0AQPM3+ajQlTCKyHBX9gpRzARE3LkzBxw=";
        };

        packageRequires = [];
      };

      fluffy-theme = emacsPackages.trivialBuild {
        pname = "fluffy-theme";
        version = "unstable";

        src = pkgs.fetchfossil {
          url = "https://fossil.avalos.me/fluffy.el";
          rev = "trunk";
          hash = "sha256-v7Edn++AX58wRMhbRLjRWUtnYcwWzoTD7IurUzBNRQk=";
        };
      };

      flymake-golangci = emacsPackages.melpaBuild {
        pname = "flymake-golangci";
        version = "1.0.2";
        src = pkgs.fetchFromGitea {
          domain = "codeberg.org";
          owner = "arouene";
          repo = "flymake-golangci.el";
          rev = "v1.0.2";
          hash = "sha256-fgcoNN9j1AUcL+ChgRMVZHDHgn45w1+xzPYRKnfmSa4=";
        };
      };

      datamacs = emacsPackages.trivialBuild rec {
        pname = "datamacs";
        version = "0.0.1";
        src = pkgs.fetchFromGitHub {
          owner = "abdivasiyev";
          repo = "datamacs";
          rev = "v${version}";
          hash = "sha256-lK/aXJ3W8hA8m9fZjuXZHiHHSy17zjgZXfK+aA52TGY=";
        };
        sourceRoot = "source/lisp";
        packageRequires = [
          emacsPackages.pg
        ];
      };

      tools = with pkgs; [
        # Common
        coreutils
        direnv
        git
        # File format converter
        pandoc
        # Time tracking
        wakatime-cli
        # Security
        gnupg

        # Language / LSP / formatter / debugger
        # Golang
        go
        gopls
        golangci-lint
        delve
        migrate
        go-swag
        # Nix
        nil
        alejandra
        # Bash
        shellcheck
        # Haskell
        hpkgs.ghc
        (lib.hiPrio hpkgs.cabal-install)
        hpkgs.cabal-add
        hpkgs.cabal-gild
        hpkgs.hoogle
        hpkgs.haskell-language-server
        hpkgs.fourmolu
        # Yaml
        yaml-language-server
        # JSON
        vscode-langservers-extracted
        # Docker
        dockerfile-language-server
        # C/C++/Clang
        clang-tools
        cmake
        # Rust
        rustc
        cargo
        rustfmt
        clippy
        rust-analyzer
        # Java
        jdk25
        # Python3
        python3
        # NodeJS
        nodejs
      ];

      toolsPath = pkgs.lib.makeBinPath tools;

      systemPath = lib.concatStringsSep ":" (
        lib.optionals pkgs.stdenv.isLinux ["/run/wrappers/bin"]
        ++ [
          "${config.home.profileDirectory}/bin"
          "/run/current-system/sw/bin"
          "/nix/var/nix/profiles/default/bin"
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          "/opt/homebrew/bin"
          "/opt/homebrew/sbin"
        ]
        ++ ["/usr/local/bin"]
      );

      # home.sessionVariables only reach programs started from a login shell
      # (hm-session-vars.sh).  Emacs launched from the Dock never sources it,
      # so eshell and other child processes miss them.  Forward the literal
      # ones; values with shell expansions ($VAR, ''${VAR:+...}) are skipped.
      elispString = s: "\"" + lib.escape ["\\" "\""] s + "\"";
      sessionVariables =
        lib.filterAttrs (_: v: !(lib.hasInfix "$" (toString v)))
        config.home.sessionVariables;

      # Secrets exported to Emacs and its child processes.  Only the sops
      # paths reach the store; init.el reads the files at startup.
      secretVariables = {
        GITHUB_TOKEN = config.sops.secrets.githubToken.path;
      };

      # Tangle emacs.org into early-init.el and init.el at build time.
      emacsConfig =
        pkgs.runCommand "emacs-config" {
          nativeBuildInputs = [pkgs.emacs-nox];
        } ''
          cp ${./emacs.org} emacs.org
          emacs --batch -Q \
            --eval "(require 'ob-tangle)" \
            --eval '(org-babel-tangle-file "emacs.org")'
          mkdir -p $out
          cp early-init.el init.el $out/
        '';
    in {
      sops.secrets = {
        githubToken = {};
      };

      # Home manager installation
      home.packages = tools;

      # Emacs configurations
      programs.emacs = {
        enable = true;
        package = emacs;

        extraPackages = epkgs:
          with epkgs; [
            # Editing / UI.
            move-text
            paredit
            multiple-cursors
            vundo
            hl-todo
            doom-themes
            gruber-darker-theme
            fluffy-theme
            gruvbox-theme
            nerd-icons
            nerd-icons-dired
            dashboard

            # Completion.
            vertico
            orderless
            smex
            company
            minuet

            # Git.
            magit
            forge
            diff-hl

            # Environment / project integration.
            envrc
            inheritenv
            dired-toggle
            trust-manager

            # Snippets / activity tracking.
            yasnippet
            yasnippet-snippets
            wakatime-mode

            # Development.
            dape
            go-mode
            flymake-golangci
            nix-mode
            haskell-mode
            markdown-mode
            proof-general
            company-coq

            # Terminal.
            vterm
            vterm-toggle

            # E-shell
            eat

            # Org extensions.
            verb
            impostman
            org-modern

            # Database client
            datamacs

            # Grammars used by built-in tree-sitter major modes.
            (treesit-grammars.with-grammars (grammars:
              with grammars; [
                tree-sitter-yaml
                tree-sitter-json
                tree-sitter-dockerfile
                tree-sitter-rust
                tree-sitter-toml
              ]))
          ];
      };

      # Exact Nix store paths required by init.el at runtime.
      home.file.".emacs.d/nix-vars.el".text =
        ''
          ;;; nix-vars.el --- generated by Home Manager -*- lexical-binding: t; -*-
          (defconst my/nix-tool-path "${toolsPath}")
          (defconst my/nix-system-path "${systemPath}")
          (defconst my/nix-coreutils-ls "${pkgs.coreutils}/bin/ls")
          (defconst my/nix-wakatime-cli "${pkgs.wakatime-cli}/bin/wakatime-cli")
          (defconst my/nix-rust-src-path "${pkgs.rustPlatform.rustLibSrc}")
          (defconst my/nix-session-variables
            '(${lib.concatStrings (lib.mapAttrsToList (n: v: "\n    (${elispString n} . ${elispString (toString v)})") sessionVariables)}))
          (defconst my/nix-secret-variables
            '(${lib.concatStrings (lib.mapAttrsToList (n: v: "\n    (${elispString n} . ${elispString v})") secretVariables)}))
        ''
        # Set by the llm.completion aspect; the port matches its llama-server.
        + lib.optionalString (config.launchd.agents.llama-completion.enable or false) ''
          (defconst my/nix-llama-completion-endpoint "http://127.0.0.1:8012/v1/completions")
        '';
      # Both files are tangled from ./emacs.org.
      home.file.".emacs.d/early-init.el".source = "${emacsConfig}/early-init.el";
      home.file.".emacs.d/init.el".source = "${emacsConfig}/init.el";
    };
  };
}
