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

alias cx=switch