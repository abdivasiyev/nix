# git wtclone <url> [upstream-url]
#
#   <root>/git/<repo>.git              bare repository
#   <root>/worktrees/<repo>/<branch>   worktrees
#
# <root> is the nearest ancestor of $PWD holding both git/ and worktrees/,
# else $PWD (both are created there).
#
# Progress goes to stderr; the created worktree path is the only thing on
# stdout, so a shell wrapper can cd into it.
emulate -L zsh
setopt err_return

local url=$1 upstream=$2
[[ -n $url ]] || { print -u2 "usage: git wtclone <url> [upstream-url]"; exit 2 }

# host/org/repo from https://host/org/repo.git or git@host:org/repo.git
# NB: never name a local 'path' in zsh -- it is tied to $PATH.
local rest=${url#*://}; rest=${rest#*@}; rest=${rest/://}
local host=${rest%%/*} loc=${rest#*/}
local repo=${loc##*/}; repo=${repo%.git}
local org=${loc%/*}; org=${org##*/}

# nearest ancestor with both git/ and worktrees/
local root="" d=$PWD
while [[ -n $d ]]; do
  [[ -d $d/git && -d $d/worktrees ]] && { root=$d; break }
  [[ $d == / ]] && break
  d=${d:h}
done
if [[ -z $root ]]; then
  root=$PWD
  mkdir -p $root/git $root/worktrees
  print -u2 "  created $root/{git,worktrees}"
fi

local bare=$root/git/$repo.git
local wtdir=$root/worktrees/$repo
[[ -e $bare ]] && { print -u2 "already exists: $bare"; exit 1 }
mkdir -p $root/git $wtdir

git clone --bare -- $url $bare 1>&2
# a bare clone carries no refspec, so `git fetch` would update nothing
git -C $bare config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
git -C $bare fetch --quiet origin

# No upstream given? Ask the host where it was mirrored from. '-' skips it.
# Credentials come from git's credential helper; the value is never echoed.
if [[ -z $upstream ]] && (( $+commands[jq] )); then
  local user=$(git config --get credential.https://$host.username)
  if [[ -n $user ]]; then
    local pw=$(printf 'protocol=https\nhost=%s\nusername=%s\n\n' $host $user \
               | git credential fill 2>/dev/null | sed -n 's/^password=//p')
    if [[ -n $pw ]]; then
      local orig=$(curl -sS -m 10 -u "$user:$pw" \
                     "https://$host/api/v1/repos/$org/$repo" 2>/dev/null \
                   | jq -r '.original_url // empty' 2>/dev/null)
      if [[ -n $orig ]]; then
        local r2=${orig#*://}
        upstream="git@${r2%%/*}:${${r2#*/}%.git}.git"
      fi
    fi
  fi
elif [[ $upstream == - ]]; then
  upstream=""
fi
[[ -n $upstream ]] && git -C $bare remote add upstream $upstream

local br=$(git -C $bare symbolic-ref --short HEAD)
git -C $bare worktree add --quiet $wtdir/$br $br
# branches from a bare clone have no upstream configured
git -C $wtdir/$br branch --quiet --set-upstream-to=origin/$br $br 2>/dev/null

print -u2 "  bare:     ${bare/#$HOME/~}"
[[ -n $upstream ]] && print -u2 "  upstream: $upstream"
print -u2 "  worktree: ${wtdir/#$HOME/~}/$br  (tracking $(git -C $wtdir/$br rev-parse --abbrev-ref '@{u}' 2>/dev/null || print none))"
print -- $wtdir/$br
