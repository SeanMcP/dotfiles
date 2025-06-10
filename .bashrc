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
