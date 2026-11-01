#!/usr/bin/env bash
# Fail if any non-merge commit in <range> touches both code and infrastructure paths.
# Commits brought in by an upstream sync merge are not ours to divide, so they are left out.
# Usage: check-commit-kinds.sh <rev-range>   (e.g. origin/development..HEAD)
set -euo pipefail
range=${1:?usage: check-commit-kinds.sh <rev-range>}
list=$(git rev-parse --show-toplevel)/.github/infra-paths
sync_subject="Merge branch 'development' of https://github.com/HaxeFoundation/haxe into development"
# In their own assignments, so that set -e stops on a range git cannot resolve.
merges=$(git log --merges --format='%H %s' "$range")
upstream=()
while read -r c subject; do
  if [[ $subject == "$sync_subject" ]]; then upstream+=("^$c^2"); fi
done <<< "$merges"
commits=$(git rev-list --no-merges "$range" "${upstream[@]}")
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
