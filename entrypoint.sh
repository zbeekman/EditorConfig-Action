#!/bin/bash
#
# Copyright 2019 Izaak Beekman
#
# This file is part of EditorConfig-Action, a "GitHub Action" available on the
# GitHub Marketplace.
#
# This project is licensed under the MIT license. Please see the accompanying
# `LICENSE` file for details.
#


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
  # git config --global --add safe.directory "$GITHUB_WORKSPACE"
}

getEventByPath() {
  # Pick out Event API payload path using jq
  jq -r "$@" "${GITHUB_EVENT_PATH}"
}

getPushedCommitInfo() {
  echo "Getting info about commits (if any) in push..."
  DELETED="$(getEventByPath '.deleted')"
  HEAD_COMMIT="$GITHUB_SHA"
  BASE_COMMIT="$(getEventByPath '.before')"
}

getPullRequestCommitInfo() {
  echo "Getting info about commits in pull request..."
  DELETED=false
  HEAD_COMMIT="$(getEventByPath '.pull_request.head.sha')"
  BASE_COMMIT="$(getEventByPath '.pull_request.base.sha')"
  PULL_ID="$(getEventByPath '.pull_request.number')"
  PR_ACTION="$(getEventByPath '.action')"
  PULL_REF="$(getEventByPath '.pull_request.head.ref')"
  FULL_PR_REF="pull/${PULL_ID}/head:${PULL_REF}"
  echo "PR_ACTION: ${PR_ACTION}"
  case "${PR_ACTION}" in
    opened | reopened | ready_for_review | synchronize)
      true # noop
      ;;
    *)
      echo "Nothing to be done for PR"
      exit 78
      ;;
  esac
  echo "Fetching commits from PR at ${FULL_PR_REF}."
  git fetch origin "${FULL_PR_REF}" || true
  echo "Current git status:"
  git status
  echo "Testing Pull Request. Attempting checkout of PR branch..."
  git fetch origin "${FULL_PR_REF}" || true
  if git checkout "${PULL_REF}" ; then
    echo "Checkout of ${PULL_REF} succeeded."
  else
    echo "Checkout of ${PULL_REF} from origin failed... attempting to continue anyway."
  fi
  git status
  git branch
  git show-ref
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
  echo "Pushed commit was: ${HEAD_COMMIT}"
  echo "Pushed commit range: ${BASE_COMMIT}..${HEAD_COMMIT}"
  have_first=false
  have_last=false
  have_commits=false
  if [ -n "${BASE_COMMIT}" ] && [ "${BASE_COMMIT}" != "null" ]; then
    have_first=true
  fi
  if [ -n "${HEAD_COMMIT}" ] && [ "$HEAD_COMMIT" != "null" ]; then
    have_last=true
  fi
  if ! $DELETED ; then
    have_commits=true
  fi
  if $have_first && $have_last ; then
    echo "We have a valid commit range..."
    CHANGED_FILES=()
    while IFS='' read -r line; do
      if [ -f "$line" ] ; then
        CHANGED_FILES+=("$line")
      else
        echo "File \`$line\` was moved or deleted."
      fi
    done < <(git diff --name-only "${HEAD_COMMIT}..${BASE_COMMIT}")
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
  if [[ "${GITHUB_EVENT_NAME}" = pull_request ]]; then
    echo "${#CHANGED_FILES[@]} files have been touched by this pull request:"
  fi
}

##############################
# Start main
##############################
echo "eclint version: $(eclint --version)"
configureGit

echo "Looking for .editorconfig file in current directory or parents..."
findInCwdOrParent .editorconfig

if [[ "${GITHUB_EVENT_NAME}" = pull_request ]] ; then
  echo "Determining HEAD and BASE commit SHAs in current pull request..."
  getPullRequestCommitInfo
else
  echo "Determining commits starting and ending SHAs in push and if the branch was deleted..."
  getPushedCommitInfo
fi

echo "Determining changed files..."
getChangedFiles

if [[ "${ALWAYS_LINT_ALL_FILES:-false}" = [Tt]rue ]]; then
  lintAllFiles
elif [ ${#CHANGED_FILES[@]} -gt 0 ]; then
  echo ""
  echo "Checking the following changed files for EditorConfig style violations:"
  for f in "${CHANGED_FILES[@]}"; do
    echo "  - $f"
  done
  echo ""
  if env eclint check "${CHANGED_FILES[@]}" ; then
    passECLint
  else
    failECLint
  fi
else
  echo "No files changed in commits:"
  echo "    ${BASE_COMMIT}..${HEAD_COMMIT}"
  exit 0
fi
