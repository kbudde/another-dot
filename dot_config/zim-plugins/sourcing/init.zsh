typeset -g SOURCING_DIR="${${(%):-%x}:h}/sources"

source_file() {
    local file="${1:a}"
    local name="${file:t}"

    [[ -e "$file" ]] || {
        print -u2 -PR "* source_file: '$file' does not exist"
        return 1
    }

    ln -sf "$file" "$SOURCING_DIR/$name"
    md5sum "$file" | awk '{print $1}' >| "$SOURCING_DIR/$name.md5"
}

_check_and_source() {
    local name="$1"
    local file="$SOURCING_DIR/$name"
    local sumfile="$file.md5"
    local stored current reply
    
    [[ -e "$file" ]] || { echo "File $file does not exist"; return 1; }
    if [[ -f "$sumfile" ]]; then
        stored="$(< "$sumfile")"
        current="$(md5sum "$file" | awk '{print $1}')"
        if [[ "$current" != "$stored" ]]; then
            print -u2 -PR "* '$name' changed on disk."
            print -u2 -PR "Trust and re-source it?"
            if read -q 'reply?[y/N] '; then
                print
                md5sum "$file" | awk '{print $1}' >| "$sumfile"
            else
                print
                echo "comparison failed, not sourcing $file - $current != $stored"
                return
            fi
        fi
    else
        echo "No md5sum for $name, failed."
    fi
    source "$file"
}

_check_source_files() {
    local f
    for f in "$SOURCING_DIR"/*(N); do
        [[ "${f:t}" == *.md5 ]] && continue
        _check_and_source "${f:t}"
    done
}

if [[ ${(%):-%x} == ${0} ]]; then
    _check_source_files
fi