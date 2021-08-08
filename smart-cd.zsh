#!/usr/bin/env zsh

# if not set, use defaults
[ ! -n "${SMART_CD_LS+1}" ] && SMART_CD_LS=true
[ ! -n "${SMART_CD_GIT_STATUS+1}" ] && SMART_CD_GIT_STATUS=true
[ ! -n "${SMART_CD_ONLY_IF_FITS_RATIO+1}" ] && SMART_CD_ONLY_IF_FITS_RATIO=false

_smart_cd_lastgitdir=''
_smart_cd_chpwd_handler () {
  emulate -L zsh

  if [[ $SMART_CD_LS == true ]]
  then
    if [[ ($SMART_CD_ONLY_IF_FITS_RATIO == false) || ($(exa -1 | wc -l) -lt $(($(tput lines) * 100/SMART_CD_ONLY_IF_FITS_RATIO))) ]]
    then
      eval "${SMART_CD_LS_COMMAND:-exa -lg --git --time-style=long-iso}"
    fi
  fi

  if [[ $SMART_CD_GIT_STATUS == true ]]
  then
    local gitdir="$(git rev-parse --git-dir 2>/dev/null)"
    if [[ -n "$gitdir" ]]
    then
      gitdir="$gitdir:A" # absolute path of $gitdir
      [[ "$gitdir" != "$_smart_cd_lastgitdir" ]] && (echo; git status)
      _smart_cd_lastgitdir="$gitdir"
    fi
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _smart_cd_chpwd_handler
