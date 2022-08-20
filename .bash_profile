function _branches() {
    if [ -n "$1" ]; then
        echo "$1"
        return
    else
        git for-each-ref --sort=committerdate refs/heads/ | awk -F'heads/' '{ print $NF }' | fzf
    fi
}

function cb() {
    branch=$(_branches)
    git checkout "${branch}"
}


