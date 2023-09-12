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
alias src="echo Sourcing from .zshrc; source $HOME/.zshrc"

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

# ss - Run a command in khan/webapp/services/static
ss() {
    bash -c "cd ~/khan/webapp/services/static && $*"
}

# ssb - Start storybook
ssb() {
    ss "yarn start:storybook"
    open -a '/Applications/Google Chrome.app' 'http://localhost:8228'
}

################
# Git
################

# PROMPT="$ "
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '[%b] '
setopt PROMPT_SUBST
PROMPT='${PWD/#$HOME/~} ${vcs_info_msg_0_}> '
