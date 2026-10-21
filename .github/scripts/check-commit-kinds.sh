#!/usr/bin/env bash
# Fail if any non-merge commit in <range> touches both code and infrastructure paths.
# Usage: check-commit-kinds.sh <rev-range>   (e.g. origin/development..HEAD)
set -euo pipefail
range=${1:?usage: check-commit-kinds.sh <rev-range>}
list=$(git rev-parse --show-toplevel)/.github/infra-paths
# In its own assignment, so that set -e stops on a range git cannot resolve.
commits=$(git rev-list --no-merges "$range")
bad=0
for c in $commits; do
  code=0 infra=0
  while IFS= read -r f; do
    kind=code
    while IFS= read -r p; do
      case $p in ''|'#'*) continue;; esac
      if [[ $f == "$p" || ( $p == */ && $f == "$p"* ) ]]; then kind=infra; break; fi
    done < "$list"
    [[ $kind == infra ]] && infra=1 || code=1
  done < <(git diff-tree --no-commit-id --name-only -r --root "$c")
  if (( code && infra )); then
    echo "::error::$(git log -1 --format='%h %s' "$c") mixes code and infrastructure; split it"
    bad=1
  fi
done
exit $bad
