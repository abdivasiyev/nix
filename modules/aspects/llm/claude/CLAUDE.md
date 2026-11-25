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

Inside the current repo, pick the cheapest tool that answers the question, in
this order, and fall back to `Grep` / reading files only when they cannot:

1. `LSP` tool — go to definition, find references, document and workspace
   symbols, for Go, Nix, Haskell, Rust, TypeScript/JavaScript, Python and PHP.
   Returns exact locations instead of whole files; use it before opening a file
   to find where something is defined or used.
2. `ast-grep` (Bash) — structural search when the question is about a code
   shape rather than a name: `ast-grep -p 'errors.Wrap($E, $MSG)' -l go`.
   Matches syntax, so comments and strings do not pollute results. `$X` is one
   node, `$$$X` any number. Go gotcha: a lone `pkg.Fn($$$A)` parses as a type
   conversion and matches nothing; wrap it and select the call instead:
   `ast-grep -p 'func _() { fmt.Println($$$A) }' --selector call_expression -l go`.
   If a pattern returns nothing, check it with `--debug-query=pattern` before
   concluding the code does not exist.
3. `Grep` — plain text: log messages, config keys, string literals, files the
   tools above do not parse.

Read a file only once you know it is the right one, and read the relevant range
rather than the whole file.

## Reuse before writing

Never write new code until you have searched for code that already does it.
This is a hard rule, not a preference.

1. Before adding any function, type, helper, module, option, script or config,
   search for an existing one: `code-graph` (`search_code` / `query_code` by
   behavior, not just by name), then a local search of the working tree,
   including shared packages (`aliftechuz/pkg`, house libraries) and the
   framework or nixpkgs/home-manager options already in use.
2. When asked about or to use existing functionality, find it and work through
   it. Do not reimplement it, wrap it in a near-duplicate, or "simplify" it into
   a new copy.
3. If something close exists, extend or call it rather than writing a parallel
   version.
4. Write new code only when the search came up empty, and say so in the
   report: what you searched for and where, e.g. "searched `code-graph` for
   'retry with backoff' and `pkg/`; nothing found, so added `x`".
5. If you are unsure whether an existing piece fits, ask rather than invent.

## Keep it simple and in scope

Hard rules, not preferences.

- Write the simplest code that does the task. No abstractions, options,
  helpers, generics or error handling for cases the task does not have. Three
  plain lines beat a clever one.
- Match the surrounding code's style instead of introducing your own.
- Comments: only where the code cannot say it — a non-obvious why, a trap, a
  constraint. One short line by default. No comments restating the code, no
  narration of the change ("added", "now", "fixed"), no banners.
- Touch only what the task needs. Do not edit, reformat, rename, reorder or
  "improve" code or comments outside it, even when they look wrong — mention
  them in the report instead.
- Never delete or rewrite an existing comment unless the code it describes
  changed in this task.
- Keep the diff minimal: if a line in the diff is not needed for the task,
  revert it before reporting.

## Keep repositories clean

A git repository holds the project and nothing else. Never create a file there
that is not part of the work being asked for: no `.claude/` directory, no notes,
plans, summaries, reports, logs, scratch scripts, backup copies or `*.bak`
files, and no helper written only to get to an answer.

Temporary files go in the scratchpad directory for the session. If a file has to
live in the repo, it is because the task asked for it.

This includes files a tool writes on your behalf — check what a command creates
before running it in a repo, and say so when something has left a stray file
behind rather than leaving it to be found later.

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
