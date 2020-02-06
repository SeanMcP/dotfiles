# Reads the scripts of a package.json in the current directory if present
alias ns="if [[ -f \"package.json\" ]]; then node -pe \"JSON.parse(require('fs').readFileSync('package.json').toString()).scripts\"; else echo \"There is no package.json in this directory\"; fi"

export PATH=$PATH:/Users/sean/scripts
