typeset -A cfg

cfg=(
    ["switcher"]="mise exec kubeswitch -- switcher init zsh"
)


for key value in ${(kv)cfg}; do
    () {
        local path="$1"
        local command="$2"
        local gen_command="$3"

        local compfile="$path/functions/_${command}"
        [[ -z $command ]] && return 1

        if [[ ! -e $compfile || $compfile -ot $(which $command) ]]; then
            eval $gen_command >| $compfile
            print -u2 -PR "* Detected a new version '$command'. Regenerated completions."
        fi
        compdef(){}
        source $compfile
        unset compdef

    }  ${0:h} "$key" "$value"
done

cx() {
    local cl
    cl=$(switch list-contexts | \
		grep -v ".kube/admin" | \
		fzf --height=80%  --info=inline --border --margin=1 --padding=1 -q "$1" -1\
		) \
		&& switch set-context "$cl"
  }

# use last by default
switch set-last-context > /dev/null 2>&1