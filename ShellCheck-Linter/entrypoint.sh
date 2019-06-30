#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

/bin/shellcheck --version

echo "Configuring git..."
# This should be the default but it's important that it's set correctly
git config --global core.quotePath true

echo "Enumerating files tracked by git..."
# We know that core.quotePath is true
# shellcheck disable=SC2207
gitfiles=($(git ls-files))

echo "Finding scripts in ${#gitfiles[@]} project files..."
scripts=()
time {
  for f in "${gitfiles[@]}"; do
    # If not a file ending in .sh or w/o a file extension cycle
    [[ "$f" =~ \.sh|/[^./]+$ ]] || continue
    file --mime -b "$f" | grep 'shellscript' > /dev/null || continue
    scripts+=("$f")
  done
}

echo "Found ${#scripts[@]} scripts."

echo "Linting ${#scripts[@]} scripts with ShellCheck..."
/bin/shellcheck "${scripts[@]}"
exit_code=$?

case $exit_code in
  0)
    echo "Congratulations, ShellCheck did not find any issues!"
    ;;
  1)
    echo "ShellCheck detected issues in your files!!!" >&2
    ;;
  2)
    echo "ShellCheck could not process some files!! Do the passed files exist?" >&2
    echo "   Do you have non-shell scripts with \`.sh\` file extensions?" >&2
    ;;
  3,4)
    echo "ShellCheck was invoked with bad syntax (e.g.  unknown flag)... OR" >&2
    echo "ShellCheck was invoked with bad options (e.g.  unknown formatter)." >&2
    echo "Please report this to the maintainer of ${GITHUB_ACTION}" >&2
    ;;
esac
exit $exit_code
