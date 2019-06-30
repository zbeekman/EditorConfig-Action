#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail

failed=false

if ! find . -name '*.sh' -exec /bin/shellcheck {} \; ; then
  failed=true
fi

if failed ; then
  exit 1
fi
