typeset -A cfg

cfg=(
    ["talosctl"]="mise exec talosctl -- talosctl completion zsh"
    ["kubeswitch"]="mise exec kubeswitch -- switcher init zsh"
    #["switch"]="switch completion zsh"
    #["env"]="production"
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
    }  ${0:h} "$key" "$value"
done