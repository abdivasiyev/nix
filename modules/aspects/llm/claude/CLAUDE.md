# Global context

Managed by home-manager from `modules/aspects/llm/claude/` in the nix config
repo. Edit it there and rebuild — editing `~/.claude/CLAUDE.md` directly is
overwritten on the next activation.

## Secrets

Never read, print or echo a secret value, in any repo or environment, including
redacted. This covers `kubectl get/describe secret`, `aws secretsmanager
get-secret-value`, `aws ssm get-parameter --with-decryption`, `vault read`,
`vault kv get`, and reading a decrypted sops file to show that it decrypts.

When work needs a credential, hand over the exact command or SQL to run.

Secrets live in sops (`secrets/secrets.yaml`, this repo) or Vaultwarden (homelab,
collection `Homelab services`). A secret must never reach the nix store, a
derivation argument, a committed file or a log line.

## Git

- Branch from a freshly fetched default branch. Take the default from
  `gh repo view --json defaultBranchRef`, not from `origin/HEAD`.
- Conventional commits: `<type>(<scope>): <subject>`, type from
  `feat fix hotfix featfix docs refactor test chore perf build ci`.
- Stage new files explicitly with `git add <file>` — never `git add .`.
- Never `--no-verify`, never `git push --force` to `main`, `master` or `develop`.
- Commit or push only when asked. If on the default branch, branch first.

## Finding code

Use the `code-graph` MCP before grepping or opening files to locate code. It
indexes roughly a hundred repos across `abdivasiyev`, `aliftechuz` and
`Metanchi` — Go, Haskell, Nix, TypeScript, Python, PHP, Kotlin, Swift, Dart —
and answers questions a text search cannot.

- `search_code` / `query_code` — find a symbol or behavior by meaning, not by
  spelling.
- `find_callers` / `find_dependencies` — blast radius before a change. Reach for
  these instead of guessing who uses something.
- `trace_endpoint` — a route to the code that serves it.
- `find_prs_for_symbol` / `find_prs_for_file` — why the code is the way it is.
- `list_services` — what is indexed, with languages and file counts.

This matters most across repo boundaries: a caller of `aliftechuz/pkg` or a
contract shared between services is not findable with a local grep.

Two limits. A repo missing from `list_services` is not indexed — use local
search, or `index_repository`. And the graph is built from pushed code, so it
does not see uncommitted work: confirm against the working tree before stating
what the code does now.

## Verification

A change is done when it has been run, not when it has been written. Before
reporting completion: build or eval it, run the tests, and show the command.

Nix changes evaluate with
`nix eval --raw .#darwinConfigurations.<host>.config.system.build.toplevel.drvPath`
and format with `nix fmt`. Hosts: `maxi` (work), `mini` (personal), `midi`
(linux). Go changes need `make lint && make test`, and `go fix -diff ./...` must
produce an empty diff.

## Agents

- `nix-reviewer` — after editing any `.nix` file in the config repo.
- `go-reviewer` — after Go changes, before opening a PR. Enforces
  `aliftechuz/mobi-standards`.
- `haskell-reviewer` — after Haskell changes. House style is `abdivasiyev/anima2d`.
- `k8s-debugger` — a workload failing, unreachable, or not matching its manifest.
- `homelab-ops` — anything touching `abdivasiyev/homelab`.
