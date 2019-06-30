#!/bin/sh

set -o errexit
set -o nounset

findEditorConfig() {
  _currdir="$PWD"
  if [ -f "$1" ]; then
    printf 'EditorConfig file found: %s\n' "${PWD%/}/$1"
  elif [ "$PWD" = / ]; then
    echo "No $1 file found in ${_currdir} or parents!" >&2
    exit 78
  else
    (cd .. && findconfig "$1")
  fi
}

echo "eclint version: $(eclint --version)"

echo "Looking for .editorconfig file in current directory or parents..."
findEditorConfig .editorconfig

echo "Checking files for EditorConfig style violations"
git config --global core.quotePath true

# shellcheck disable=SC2046
if env eclint check $(git ls-files) ; then
    echo "No style violations found." >&2
else
  echo "Style violations found!"
  exit 1
fi
