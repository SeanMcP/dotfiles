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

    prompt+="\n${GRAY}\$ ${RESET}"

    export PS1="$prompt"
}

PROMPT_COMMAND=update_ps1

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

# send a message to the void
void() {
    bash -c "cd ~/seanmcp/seanmcp.com && pnpm void $*"
}
