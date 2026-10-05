# git wtadd <branch> [dir-name]
# Add a worktree beside the current one. Run from inside any worktree.
# dir-name defaults to the branch with / -> -.
# The created path is the only thing on stdout.
emulate -L zsh
setopt err_return

local br=$1 name=${2:-${1//\//-}}
[[ -n $br ]] || { print -u2 "usage: git wtadd <branch> [dir-name]"; exit 2 }
local wt=$(git rev-parse --show-toplevel) || exit 1
local parent=${wt:h}

if git show-ref --verify --quiet refs/heads/$br; then
  git worktree add $parent/$name $br 1>&2                       # existing local branch
elif git show-ref --verify --quiet refs/remotes/origin/$br; then
  git worktree add --track -b $br $parent/$name origin/$br 1>&2 # remote branch
else
  git worktree add -b $br $parent/$name 1>&2                    # new branch
fi
print -- $parent/$name
