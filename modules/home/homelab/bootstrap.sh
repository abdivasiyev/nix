# homelab-bootstrap [--ask]
#
# Rebuild the homelab on this Mac from nothing: the OrbStack machine, its
# configuration, and its data from ~/Homelab/backups. For a wiped or new Mac
# mini; on one that already has the machine it says so and does nothing.
#
#   1. clone the homelab repo from GitHub (Forgejo lives on the homelab, so
#      it is gone too) into the usual git/ + worktrees/ layout
#   2. just create / just bootstrap: the machine, ~/Homelab, its age key
#   3. put the new machine key into .sops.yaml, re-encrypt the secrets for it,
#      commit, push to GitHub
#   4. just deploy (a first deploy downloads everything; allow a while)
#   5. just restore: newest backups back in, then the machine reboots
#   6. once Forgejo answers again, push the key commit there too, so the
#      GitOps deployer (which follows Forgejo) sees it
#
# --ask is the first-terminal check from zsh: ask once, remember the answer.

MACHINE=homelab
BASE=$HOME/Development/git.azizovich.uz/abdivasiyev
BARE=$BASE/git/homelab.git
WT=$BASE/worktrees/homelab/master
GITHUB=git@github.com:abdivasiyev/homelab.git
FORGEJO=https://git.azizovich.uz/abdivasiyev/homelab.git
AGE_KEY=$HOME/.config/sops/age/keys.txt
STATE=${XDG_STATE_HOME:-$HOME/.local/state}/homelab-bootstrap

say() { printf '\033[1m==> %s\033[0m\n' "$*" >&2; }
die() { printf '\033[31merror:\033[0m %s\n' "$*" >&2; exit 1; }

machine_exists() { orbctl list -q 2>/dev/null | grep -qx "$MACHINE"; }

if [ "${1:-}" = "--ask" ]; then
  mkdir -p "$STATE"
  command -v orbctl >/dev/null || exit 0 # OrbStack not installed (yet)
  if machine_exists; then
    touch "$STATE/done"
    exit 0
  fi
  n=$(find "$HOME/Homelab/backups" -type f 2>/dev/null | wc -l | tr -d ' ')
  echo
  echo "No '$MACHINE' machine in OrbStack on this Mac."
  echo "Build the homelab now? This clones it from GitHub, creates and deploys"
  echo "the machine, and restores ~/Homelab/backups ($n backup files found)."
  printf 'Build it now? [y/N] '
  read -r answer || answer=
  case $answer in
    y | Y | yes) ;;
    *)
      touch "$STATE/declined"
      echo "Not asking again. Build it any time with: homelab-bootstrap"
      exit 0
      ;;
  esac
fi

# --- preconditions ----------------------------------------------------------
command -v orbctl >/dev/null || die "OrbStack is not installed (it comes from Homebrew with this config; switch first)"
if ! orbctl status 2>/dev/null | grep -qi running; then
  say "starting OrbStack"
  orbctl start
fi
[ -s "$AGE_KEY" ] || die "no age key at $AGE_KEY -- restore it first; the homelab's secrets are encrypted to it"
if machine_exists; then
  say "the '$MACHINE' machine already exists; nothing to do"
  mkdir -p "$STATE" && touch "$STATE/done"
  exit 0
fi

# --- 1. the repository ------------------------------------------------------
if [ ! -d "$BARE" ]; then
  say "cloning $GITHUB"
  mkdir -p "$BASE/git" "$(dirname "$WT")"
  git clone --bare --quiet "$GITHUB" "$BARE"
  git -C "$BARE" remote rename origin upstream
  git -C "$BARE" config remote.upstream.fetch '+refs/heads/*:refs/remotes/upstream/*'
  git -C "$BARE" remote add origin "$FORGEJO"
  git -C "$BARE" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
  git -C "$BARE" fetch --quiet upstream
fi
if [ ! -d "$WT" ]; then
  git -C "$BARE" worktree add --quiet --relative-paths "$WT" master
  git -C "$WT" branch --quiet --set-upstream-to=upstream/master master
fi
cd "$WT"
git pull --quiet --ff-only upstream master || say "could not update from GitHub; using what is checked out"

# --- 2. the machine ---------------------------------------------------------
say "creating the OrbStack machine"
just create
say "generating the machine's age key"
out=$(just bootstrap 2>&1 | tee /dev/stderr)
key=$(printf '%s\n' "$out" | sed -n 's/^==> machine: *\(age1[0-9a-z]*\).*/\1/p' | tail -1)
[ -n "$key" ] || die "could not read the machine's age key from 'just bootstrap'"

# --- 3. secrets for the new key --------------------------------------------
if ! grep -q "&homelab $key" .sops.yaml; then
  say "re-encrypting secrets for the new machine key"
  sed -i.bak -E "s|(&homelab )age1[0-9a-z]+|\\1$key|" .sops.yaml && rm -f .sops.yaml.bak
  grep -q "&homelab $key" .sops.yaml || die ".sops.yaml has no '&homelab' key line to replace"
  for f in secrets/*.yaml; do
    SOPS_AGE_KEY_FILE=$AGE_KEY sops updatekeys --yes "$f"
  done
  git add .sops.yaml secrets/
  git commit --quiet -m "bootstrap: secrets for the rebuilt machine's age key"
  git push --quiet upstream master || say "WARNING: push to GitHub failed; push it yourself: git -C $WT push upstream master"
fi

# --- 4. deploy --------------------------------------------------------------
say "deploying (the first one downloads everything)"
just deploy

# --- 5. data ----------------------------------------------------------------
say "restoring the newest backups; the machine reboots afterwards"
just restore || true # the reboot cuts the session off
sleep 10
for _ in $(seq 1 60); do
  orb run -m "$MACHINE" true >/dev/null 2>&1 && break
  sleep 5
done
orb run -m "$MACHINE" systemctl is-system-running --wait || true
orb run -m "$MACHINE" systemctl --no-pager --failed || true

# --- 6. Forgejo --------------------------------------------------------------
say "waiting for Forgejo to push the key commit there"
pushed=0
for _ in $(seq 1 60); do
  if git ls-remote --quiet origin HEAD >/dev/null 2>&1; then
    git push --quiet origin master && pushed=1
    break
  fi
  sleep 10
done
if [ "$pushed" = 1 ]; then
  git branch --quiet --set-upstream-to=origin/master master || true
else
  say "WARNING: Forgejo did not answer; once it does: git -C $WT push origin master"
fi

mkdir -p "$STATE" && touch "$STATE/done"
say "done. The homelab is at $WT; check it with: just status"
