################
# Variables
################
export DEV_DIR="$HOME/dev"

################
# Aliases
################
alias blog="code $DEV_DIR/seanmcp/seanmcp.com"
alias boop="osascript -e 'display notification \"done\" sound name \"default\"'"
alias dc=docker-compose
alias flog="docker-compose logs -f"
alias glc="git rev-parse HEAD | pbcopy"
alias grepjs='grep -rno --exclude-dir=node_modules --exclude-dir=".git" --exclude-dir=cache --exclude="*-lock.*"'
alias meet="open -a '/Applications/Google Chrome.app' 'https://meet.google.com/'"
alias src="source ~/.zshrc && echo 'Sourced from .zshrc'"
alias zrc="code ~/.zshrc"

################
# Functions
################

# Remove up-to-date git repositories
function cleanup-repos() {
  for D in *; do
    if [ -d "${D}" ]; then
      cd $D

      if [[ -d .git ]]; then
        # git pull
        changes=$(git status | grep "use \"git" | wc -l | grep -o "[0-9]\+")

        if [[ $changes = 0 ]]; then
          echo -n "Do you want to remove $D? (Y/n) "
          read answer

          if [[ $answer = "Y" ]]; then
            # Remove directory
            echo "Removing $D"
            cd ..
            rm -rf "$D"
          else
            # Don't remove directory
            echo "Preserving $D"
            cd ..
          fi
        else
          # There are changes!
          echo "Changes found in $D. Resolve those and run this script again."
          cd ..
        fi
      else
        # No .git directory
        echo "Skipping $D (no .git directory)"
        cd ..
      fi
    fi
  done
}

# rpj - Read package.json
function rpj () {
  if [[ -f "package.json" ]]; then
      node -pe "JSON.parse(require('fs').readFileSync('package.json').toString())['$1' || 'scripts']"
  else
      echo "There is no `package.json` in this directory"
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

# Keep the computer and display awake for a number of minutes.
hang() {
  setopt localoptions localtraps
  unsetopt octalzeroes
  if (( $# != 1 )) || [[ ! $1 =~ '^([0-9]+([.][0-9]*)?|[.][0-9]+)$' ]]; then
    print -u2 'Usage: hang <positive number of minutes>'
    return 1
  fi

  local -F minutes=$1
  local -i seconds=$(( minutes * 60 + 0.5 ))
  if (( minutes <= 0 || seconds < 1 )); then
    print -u2 'Specify a positive duration that rounds to at least 1 second.'
    return 1
  fi

  local hours duration
  if (( seconds < 60 )); then
    duration="$seconds second"
    (( seconds != 1 )) && duration+='s'
  elif (( minutes < 60 )); then
    printf -v duration '%g' "$minutes"
    duration+=' minute'
    (( minutes != 1 )) && duration+='s'
  else
    printf -v hours '%.2f' "$(( minutes / 60.0 ))"
    while [[ $hours == *0 ]]; do hours=${hours%0}; done
    hours=${hours%.}
    duration="$hours hour"
    (( minutes != 60 )) && duration+='s'
  fi

  local -i started=$SECONDS elapsed interrupted=0 result
  trap 'interrupted=1; print' INT
  print -r -- "🦧 Hanging for $duration"
  caffeinate -di -t "$seconds"
  result=$?
  elapsed=$(( SECONDS - started ))

  # A completed timer reports its requested duration, excluding process overhead.
  if (( !interrupted && result == 0 )); then
    print -r -- "🤙 Hung for $duration"
    return 0
  fi

  if (( elapsed < 60 )); then
    duration="$elapsed second"
    (( elapsed != 1 )) && duration+='s'
  elif (( elapsed < 3600 )); then
    local -i elapsed_minutes=$(( elapsed / 60 ))
    duration="$elapsed_minutes minute"
    (( elapsed_minutes != 1 )) && duration+='s'
  else
    printf -v hours '%.2f' "$(( elapsed / 3600.0 ))"
    while [[ $hours == *0 ]]; do hours=${hours%0}; done
    hours=${hours%.}
    duration="$hours hour"
    [[ $hours != 1 ]] && duration+='s'
  fi

  print -r -- "🤙 Hung for $duration"
  (( interrupted )) && return 130
  return $result
}

################
# Git
################

##################################################
# Prompt
##################################################

setopt PROMPT_SUBST

git_prompt_info() {
    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)

    # Detached HEAD: fall back to the short commit hash
    if [[ -z $branch ]]; then
        branch=$(git rev-parse --short HEAD 2>/dev/null)
    fi

    # Not in a git repo: print nothing
    if [[ -z $branch ]]; then
        return
    fi

    local dirty=""
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        dirty="*"
    fi

    echo "%F{blue}git:(%F{green}${branch}%F{blue})%F{red}${dirty}%f "
}

PROMPT='%1~ $(git_prompt_info)$ '
