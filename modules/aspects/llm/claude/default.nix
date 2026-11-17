{
  den.aspects.llm.claude = {
    homeManager = {
      pkgs,
      lib,
      config,
      ...
    }: let
      # Cloudflare Access credentials shared by every mcp.azizovich.uz server.
      cfAccessEnv = {
        CF_ID.file = config.sops.secrets.cfAccessClientId.path;
        CF_SECRET.file = config.sops.secrets.cfAccessClientSecret.path;
      };

      # mcp-remote expands ${CF_ID} / ${CF_SECRET} from the environment, so the
      # header arguments stay free of credentials in the nix store.
      behindCfAccess = path: {
        command = "npx";
        args = [
          "-y"
          "mcp-remote"
          "https://mcp.azizovich.uz/${path}/mcp"
          "--header"
          "CF-Access-Client-Id:\${CF_ID}"
          "--header"
          "CF-Access-Client-Secret:\${CF_SECRET}"
        ];
        env = cfAccessEnv;
      };

      version = "2.1.326";

      claude-code = pkgs.claude-code.override {
        manifest = pkgs.lib.importJSON (builtins.fetchurl {
          url = "https://downloads.claude.ai/claude-code-releases/${version}/manifest.json";
          sha256 = "07pbidmqn4hg8fv38r5j8r7fs5a45rlhvjfd4m14x8yl0lxiagl8";
        });
      };
    in {
      sops.secrets = {
        cfAccessClientId = {};
        cfAccessClientSecret = {};
        sentryAccessToken = {};
        githubToken = {};
      };

      home.packages = with pkgs; [
        nodejs
        github-mcp-server
      ];

      # The pinned nixpkgs claude-code wrapper only sets CLAUDE_CODE_CERT_STORE=system,
      # which fails TLS verification on darwin; point it at the system CA bundle.
      home.sessionVariables.NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-certificates.crt";

      programs.claude-code = {
        enable = true;
        package = claude-code;
        enableMcpIntegration = true;

        # ~/.claude/CLAUDE.md -- loaded into every session.
        context = ./CLAUDE.md;

        # ~/.claude/agents/<name>.md -- invoked explicitly or picked by description.
        agents = {
          nix-reviewer = ./agents/nix-reviewer.md;
          go-reviewer = ./agents/go-reviewer.md;
          haskell-reviewer = ./agents/haskell-reviewer.md;
          k8s-debugger = ./agents/k8s-debugger.md;
          homelab-ops = ./agents/homelab-ops.md;
        };

        # Output styles replace part of the built-in system prompt.
        # Switch at runtime with /output-style.
        outputStyles.grounded = ./output-styles/grounded.md;

        settings = {
          outputStyle = "grounded";
          includeCoAuthoredBy = false;

          # Applied to every session, whether started from a shell or from
          # claude-code-ide in Emacs.
          env = {
            DISABLE_TELEMETRY = "1";
            DISABLE_ERROR_REPORTING = "1";
            CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1";
            CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
          };
        };
      };

      programs.mcp = {
        enable = true;

        servers = {
          voicelab = behindCfAccess "voicelab";
          Anima2d-mcp = behindCfAccess "anima2d";
          code-graph-mcp = behindCfAccess "code-graph";
          forgejo = behindCfAccess "forgejo";
          knowledge = behindCfAccess "knowledge";
          dev-docs = behindCfAccess "docs";

          sentry = {
            command = "npx";
            args = [
              "-y"
              "@sentry/mcp-server@latest"
              "--disable-skills=seer"
            ];
            env = {
              SENTRY_HOST = "sentry.k8s.alifnasiya.uz";
              SENTRY_AUTH_TOKEN.file = config.sops.secrets.sentryAccessToken.path;
            };
          };

          github = {
            command = lib.getExe pkgs.github-mcp-server;
            args = ["stdio"];
            env = {
              GITHUB_PERSONAL_ACCESS_TOKEN.file = config.sops.secrets.githubToken.path;
            };
          };
        };
      };
    };
  };
}
