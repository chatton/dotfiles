export PATH="$PATH:/opt/homebrew/bin"
export PATH="$PATH:/usr/local/bin"

alias smb="git stash && git checkout main && git pull"
alias mb="git checkout main && git pull"

# enable fzf with reverse search
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

function _branches() {
    if [ -n "$1" ]; then
        echo "$1"
        return
    else
        git for-each-ref --sort=committerdate refs/heads/ | awk -F'heads/' '{ print $NF }' | fzf
    fi
}

function cb() {
    gh co
#     gh alias set co --shell 'id="$(gh pr list -L100 | fzf | cut -f1)"; [ -n "$id" ] && gh pr checkout "$id"'
#     branch=$(_branches)
#     git checkout "${branch}"
}

# gh pr list | fzf | awk '{print $1}' | gh pr view --web
function _parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

function monitors() {
    displayplacer "id:379F6649-AFE1-4C4E-8116-12D48D540E1A res:3008x1692 hz:60 color_depth:8 scaling:on origin:(0,0) degree:0" "id:37D8832A-2D66-02CA-B9F7-8F30A301B230 res:1512x982 hz:120 color_depth:8 scaling:on origin:(-1512,1234) degree:0" "id:88A56A42-DB0F-49F3-92D3-51743598D734 res:1692x3008 hz:30 color_depth:8 scaling:on origin:(3008,-1316) degree:90"
}

# display git branch in the terminal prompt
export PS1='\[\e[1;91m\][\w]\[\e[0m\]\[\e[32m\]$(_parse_git_branch)\[\e[00m\]$ '


#######################
# gh utility functions
#######################

function _get_pr_id(){
    if [ -n "$1" ]; then
        echo "$1"
        return
    else
        gh pr list --limit 100 | fzf | awk '{print $1}'
    fi
}

function _get_issue_id(){
    if [ -n "$1" ]; then
        echo "$1"
        return
    else
        gh issue list --limit 100 | fzf | awk '{print $1}'
    fi
}

function _get_my_pr_id(){
    if [ -n "$1" ]; then
        echo "$1"
        return
    else
        gh pr list --author @me | fzf | awk '{print $1}'
    fi
}

function _get_my_issue_id(){
    if [ -n "$1" ]; then
        echo "$1"
        return
    else
        gh issue list --limit 100 --assignee @me | fzf | awk '{print $1}'
    fi
}


# pr_view opens a pr selected interactively in a browser
function pr_view(){
    local pr_id="$(_get_pr_id)"
    gh pr view "${pr_id}" --web
}

# my_pr_view opens once of my prs selected interactively in a browser
function my_pr_view(){
    local pr_id="$(_get_my_pr_id)"
    gh pr view "${pr_id}" --web
}

# pr_view opens a pr selected interactively in a browser
function issue_view(){
    local issue_id="$(_get_issue_id)"
    gh issue view "${issue_id}" --web
}

function my_issue_view(){
    local issue_id="$(_get_my_issue_id)"
    gh issue view "${issue_id}" --web
}

# my_pr_view opens once of my prs selected interactively in a browser
function my_pr_view(){
    local pr_id="$(_get_my_pr_id)"
    gh pr view "${pr_id}" --web
}

# my_issues lists issues assinged to me
function my_issues(){
    gh issue list --assignee @me
}

# my_prs lists all prs that I've created
function my_prs(){
    gh pr list --author @me
}

function view_my_prs(){
    pr_numbers="$(gh pr list --author @me --json number  | jq '.[]|.number')"
    for pr in $pr_numbers; do
        gh pr view $pr --web
    done
}


# new_issue_branch creates an issue branch based off of a github issue
function new_issue_branch() {
    local issueNumber=$1
    local issueDescription=$(gh issue view ${issueNumber} --repo cosmos/ibc-go --json title | jq -r .title | awk '{print tolower($0)}' | tr " " - | sed s/'[`:()]'//g)
    git checkout -b "cian/issue#${issueNumber}-${issueDescription}"
}

. "$HOME/.cargo/env"
