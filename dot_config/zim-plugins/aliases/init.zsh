alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias gc='git checkout'
alias ga='git add'
alias gaa='git add .'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gst='git status'
alias gp='git push'
alias gpl='git pull'
alias gclean="git fetch origin --prune; git branch --merged|grep -Ev '^(\*|  (main|master))' | xargs -n 1 git branch -d"

gaam(){
    git add .
    git commit -m "$*"
}

gcb(){
    branch_name=$*
    if [ -z "$branch_name" ]; then
        echo "Branch name is required"
        return 1
    fi
    branch_name=${branch_name// /_}
    git checkout -b "$branch_name"
}

# gpmr(){
#     if [ -z "$1" ]; then
#         git push -o merge_request.create
#     else
#         git push -o merge_request.create -o merge_request.target="$1"
#     fi
# }