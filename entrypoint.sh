#!/bin/bash

set -o errexit
set -o nounset

findInCwdOrParent() {
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

configureGit() {
  # This should be the default but it's important that it's set correctly
  git config --global core.quotePath true
}

getEventByPath() {
  # Pick out Event API payload path using jq
  jq -r "$@" "${GITHUB_EVENT_PATH}"
}

getPushedCommitInfo() {
  echo "Getting info about commits (if any) in push..."
  DELETED="$(getEventByPath '.deleted')"
  BEFORE_COMMIT="$(getEventByPath '.before')"
}

failECLint() {
  echo "EditorConfig tyle violations found!" >&2
  exit 1
}
passECLint() {
  echo "No EditorConfig style violations found."
  exit 0
}

lintAllFiles() {
  echo "Checking files for EditorConfig style violations"
  # shellcheck disable=SC2046
  if env eclint check $(git ls-files) ; then
    passECLint
  else
    failECLint
  fi
}

getChangedFiles() {
  echo "Getting changed files in last push by ${GITHUB_ACTOR} to ${GITHUB_REPOSITORY}:${GITHUB_REF}..."
  echo "Pushed commit was: ${GITHUB_SHA}"
  echo "Pushed commit range: ${BEFORE_COMMIT}..${GITHUB_SHA}"
  have_first=false
  have_last=false
  have_commits=false
  if [ -n "${BEFORE_COMMIT}" ] && [ "${BEFORE_COMMIT}" != "null" ]; then
    have_first=true
  fi
  if [ -n "${GITHUB_SHA}" ] && [ "$GITHUB_SHA" != "null" ]; then
    have_last=true
  fi
  if ! $DELETED ; then
    have_commits=true
  fi
  if $have_first && $have_last ; then
    echo "We have a valid commit range..."
    CHANGED_FILES=()
    while IFS='' read -r line; do
      CHANGED_FILES+=("$line")
    done < <(git diff --name-only "${GITHUB_SHA}..${BEFORE_COMMIT}")
  elif $have_last && $have_commits ; then
    echo "Missing starting commit, new repo?"
    # We know that core.quotePath is true
    # shellcheck disable=SC2207
    CHANGED_FILES=($(git ls-files))
  elif $have_last && ! $have_commits ; then
    echo "Have current SHA, but 0 commits pushed, doing nothing!"
    exit 0
  else
    echo "Unknown error: Can't determine changed files from Git!" >&2
    exit 78
  fi
}

# Start main
echo "eclint version: $(eclint --version)"
configureGit
echo "Looking for .editorconfig file in current directory or parents..."
findInCwdOrParent .editorconfig
echo "Determining number of commits in push and starting and ending SHAs..."
getPushedCommitInfo
echo "Determining changed files..."
getChangedFiles

if [[ "${ALWAYS_LINT_ALL_FILES:-false}" = [Tt]rue ]]; then
  lintAllFiles
elif [ ${#CHANGED_FILES[@]} -gt 0 ]; then
  echo ""
  echo "Checking the following changed files for EditorConfig style violations:"
  for f in "${CHANGED_FILES[@]}"; do
    echo "    $f"
  done
  echo ""
  if env eclint check "${CHANGED_FILES[@]}" ; then
    passECLint
  else
    failECLint
  fi
else
  echo "No files changed in commits:"
  echo "    ${BEFORE_COMMIT}..${GITHUB_SHA}"
  exit 0
fi
