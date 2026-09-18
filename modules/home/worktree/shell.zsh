# Thin wrappers around `git wtclone` / `git wtadd` that also cd into the
# worktree they create -- a subprocess cannot change its parent's directory,
# so the cd has to happen in the shell.
#
# oh-my-zsh's git plugin defines gcl as an alias for `git clone`; aliases are
# expanded before function lookup, so it has to go before gcl() is parsed.
unalias gcl 2>/dev/null

gcl() {
  emulate -L zsh
  local d
  d=$(git wtclone "$@") || return $?
  [[ -n $d ]] && cd $d
}

gwadd() {
  emulate -L zsh
  local d
  d=$(git wtadd "$@") || return $?
  [[ -n $d ]] && cd $d
}
