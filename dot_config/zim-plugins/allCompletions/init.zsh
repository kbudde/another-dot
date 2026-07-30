typeset -A cfg

cfg=(
    ["crane"]='crane completion zsh'
    ["talosctl"]="talosctl completion zsh"
    ["stackit"]="stackit completion zsh"
    ["k9s"]="k9s completion zsh"
    ["starship"]="starship completions zsh"
    ["lima"]="limactl completion zsh"
    ["argocd"]="argocd completion zsh"
    ["just"]="just --completions zsh"
    ["kubara"]="kubara completion zsh"
    ["jira"]="jira completion zsh"
    ["myks"]="myks completion zsh"
)

() {
    for command gen_command in ${(kv)cfg}; do
        local compfile="$1/functions/_${command}"
        [[ -z $command ]] && return 1
        [ -s $compfile ] || rm "$compfile" # clean up empty file
        if [[ ! -e $compfile || $compfile -ot $(which $command) ]]; then
            eval $gen_command >| $compfile
            print -u2 -PR "* Detected a new version '$command'. Regenerated completions."
        fi
    done
}  ${0:h} 


fpath=("$zmodule" $fpath)
