(( ${+commands[fnm]} )) && () {

  local command=${commands[fnm]}
  [[ -z $command ]] && return 1

  local compfile=$1/functions/_fnm
  if [[ ! -e $compfile || $compfile -ot $command ]]; then
    $command completions --shell zsh >| $compfile
    print -u2 -PR "* Detected a new version 'fnm'. Regenerated completions."
  fi

  eval "$(fnm env --use-on-cd --shell zsh)"
} ${0:h}