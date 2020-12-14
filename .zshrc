# Functions


# rpj - Read package.json
function rpj () {
  if [[ -f "package.json" ]]; then
      node -pe "JSON.parse(require('fs').readFileSync('package.json').toString())['$1' || 'scripts']"
  else
      echo "There is no `package.json` in this directory"
  fi
}

# reflect
function reflect () {
  date_string=$(date +%Y-%m-%d)
  dir_path="$NOTES_DIR/reflections"
  mkdir -p $dir_path
  file_path="$dir_path/$date_string.md"
  echo "# Reflect $date_string\n\n## How did this week go?\n\n\n\n## What did you enjoy most this week?\n\n\n\n## What did you dislike this week?\n\n\n\n## What, if anything, set you back this week?\n\n\n\n## What are you going to try differently next week?" > $file_path
  code $file_path
}

# note
# @param string - The name of the note, e.g. "How the west was won"
function   new-note () {
  title="Scratchpad"
  date_string=$(date +%Y-%m-%d)
  dir_path="$NOTES_DIR/unorganized"
  mkdir -p $dir_path

  if [[ -n "$1" ]]
    then
      title=$1
  fi

  file_path="$dir_path/${date_string}_${title:l:gs/\ /\-}.md"

  echo "# $title ($date_string)\n" > $file_path

  code -g $file_path:3:0
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
