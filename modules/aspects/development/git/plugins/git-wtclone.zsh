# git wtclone <url>
#
#   <url> becomes the only remote, origin.
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

local url=$1
[[ $# -eq 1 && -n $url ]] || { print -u2 "usage: git wtclone <url>"; exit 2 }

# repo from https://host/org/repo.git or git@host:org/repo.git
# NB: never name a local 'path' in zsh -- it is tied to $PATH.
local repo=${${url%/}##*[/:]}; repo=${repo%.git}

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

local br=$(git -C $bare symbolic-ref --short HEAD)
git -C $bare worktree add --quiet $wtdir/$br $br
# branches from a bare clone have no upstream configured
git -C $wtdir/$br branch --quiet --set-upstream-to=origin/$br $br 2>/dev/null

print -u2 "  bare:     ${bare/#$HOME/~}"
print -u2 "  origin:   $url"
print -u2 "  worktree: ${wtdir/#$HOME/~}/$br  (tracking $(git -C $wtdir/$br rev-parse --abbrev-ref '@{u}' 2>/dev/null || print none))"
print -- $wtdir/$br
