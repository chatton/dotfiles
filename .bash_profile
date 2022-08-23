export PATH="$PATH:/opt/homebrew/bin"

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


function _parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

function monitors() {
    displayplacer "id:379F6649-AFE1-4C4E-8116-12D48D540E1A res:3008x1692 hz:60 color_depth:8 scaling:on origin:(0,0) degree:0" "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1512x982 hz:120 color_depth:8 scaling:on origin:(-1512,1234) degree:0" "id:88A56A42-DB0F-49F3-92D3-51743598D734 res:1692x3008 hz:30 color_depth:8 scaling:on origin:(3008,-1316) degree:90"
}

# display git branch in the terminal prompt
export PS1='\[\e[1;91m\][\w]\[\e[0m\]\[\e[32m\]$(_parse_git_branch)\[\e[00m\]$ '


function my_issues(){
    gh issue list --assignee @me
}

function my_prs(){
    gh issue list --assignee @me
}

# new_issue_branch creates an issue branch based off of a github issue
function new_issue_branch() {
    local issueNumber=$1
    local issueDescription=$(gh issue view ${issueNumber} --repo cosmos/ibc-go --json title | jq -r .title | awk '{print tolower($0)}' | tr " " - | sed s/'[`:()]'//g)
    git checkout -b "cian/issue#${issueNumber}-${issueDescription}"
}
