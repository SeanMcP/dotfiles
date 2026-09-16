# .bash_profile from my time at Khan Academy

################
# Path
################
export PATH="/Users/seanmcpherson/seanmcp/scripts:$PATH"

################
# Misc
################

################
# Prompt
################
GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
GRAY="\[\033[0;90m\]"
RESET="\[\033[0m\]"

# Function to dynamically update PS1
update_ps1() {
    local prompt="${GREEN}\W/${RESET}"
    local git_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [[ "$git_branch" != "HEAD" ]] && [[ -n "$git_branch" ]]; then
        prompt+=" ${BLUE}git($git_branch)${RESET}"
    fi

    prompt+=" ${GRAY}\$ ${RESET}"

    export PS1="$prompt"
}

PROMPT_COMMAND=update_ps1

################
# Aliases
################
alias lhup="ping localhost -P 8090"
alias sim="open -a Simulator"
alias src="echo Sourcing from .bash_profile; source $HOME/.bash_profile"
alias py-reset="rm -rf venv && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt"
alias site="code ~/seanmcp/seanmcp.com"

################
# Functions
################

# determine package manager and run command
pm() {
    if [[ -f bun.lockb ]]; then
        command bun "$@"
    elif [[ -f pnpm-lock.yaml ]]; then
        command pnpm "$@"
    elif [[ -f yarn.lock ]]; then
        command yarn "$@"
    elif [[ -f package-lock.json ]]; then
        command npm "$@"
    else
        command pnpm "$@"
    fi
}

# serve the current directory with Python
function serve() {
  port=3030

  if [[ -n "$1" ]]
    then
      port=$1
  fi

  python3 -m http.server $port
}

source ~/seanmcp/notes/.scripts/notes.sh
source ~/seanmcp/bookmarks/.scripts/bookmarks.sh

void() {
    bash -c "cd ~/seanmcp/seanmcp.com && pnpm void '$*'"
}

# cgb, Copy Git Branch - copies the current git branch name to the clipboard
cgb() {
    branch=$(git branch --show-current)
    if [ -z "$branch" ]; then
        echo "Not in a git repository or no branch found."
        return 1
    fi
    echo -n "$branch" | pbcopy
    echo "Copied branch name '$branch' to clipboard."
}

# grepall PATTERN... — list files containing ALL given patterns
grepall() {
    [ "$#" -ge 1 ] || { echo "usage: grepall PATTERN..." >&2; return 1; }

    local first="$1"; shift
    local cmd="grep -rl -- \"\$first\" ."
    for p in "$@"; do
        cmd+=" | xargs grep -l -- \"$p\""
    done
    eval "$cmd"
}
