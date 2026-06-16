(( ${+commands[kubie]} )) && () {

  local command=${commands[kubie]}
  [[ -z $command ]] && return 1

  local compfile=$1/functions/_kubie
  if [[ ! -e $compfile || $compfile -ot $command ]]; then
    $command generate-completion zsh >| $compfile
    print -u2 -PR "* Detected a new version 'kubie'. Regenerated completions."
  fi
} ${0:h}