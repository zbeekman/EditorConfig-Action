#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

echo "Looking for scripts the current project..."
scripts=(find . -name '*.sh')
echo "Found ${#scripts[@]} scripts."

echo "Linting ${#scripts[@]}} scripts with ShellCheck..."
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
