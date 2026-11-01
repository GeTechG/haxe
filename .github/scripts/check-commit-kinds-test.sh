#!/usr/bin/env bash
# Self-test: a code-only and an infra-only commit pass, a mixed one fails, so does a range git cannot resolve.
# A mixed commit behind an upstream sync merge passes; behind an ordinary merge, or beside a sync merge, it fails.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
t=$(mktemp -d); trap 'rm -rf "$t"' EXIT
cd "$t"
git init -q; git config user.email t@t; git config user.name t
mkdir -p .github std openspec
cp "$here/../infra-paths" .github/infra-paths
echo a > std/a.hx; git add -A; git commit -qm base
base=$(git rev-parse HEAD)
echo b >> std/a.hx; git commit -qam code
echo c > AGENTS.md; echo d > openspec/x.md; git add -A; git commit -qm infra
"$here/check-commit-kinds.sh" "$base..HEAD" || { echo "FAIL: clean history rejected"; exit 1; }
ok=$(git rev-parse HEAD)
echo e >> std/a.hx; echo f >> AGENTS.md; git commit -qam mixed
if "$here/check-commit-kinds.sh" "$ok..HEAD"; then echo "FAIL: mixed commit accepted"; exit 1; fi
if "$here/check-commit-kinds.sh" refs/heads/missing..HEAD 2>/dev/null; then echo "FAIL: unresolvable range accepted"; exit 1; fi

sync_subject="Merge branch 'development' of https://github.com/HaxeFoundation/haxe into development"
git checkout -q -b upstream "$ok"
echo g >> std/a.hx; echo h >> AGENTS.md; git commit -qam "mixed upstream"
git checkout -q -b sync "$ok"
git merge -q --no-ff -m "$sync_subject" upstream
"$here/check-commit-kinds.sh" "$ok..HEAD" || { echo "FAIL: mixed commit behind a sync merge rejected"; exit 1; }
synced=$(git rev-parse HEAD)
git checkout -q -b landed "$ok"
echo i >> std/b.hx; git add -A; git commit -qm "code of ours"
git merge -q --no-ff -m "Merge branch 'sync' into development" sync
"$here/check-commit-kinds.sh" "$ok..HEAD" || { echo "FAIL: sync merge inside a landed branch: mixed commit rejected"; exit 1; }
git checkout -q sync
echo j >> std/a.hx; echo k >> AGENTS.md; git commit -qam "mixed of ours"
if "$here/check-commit-kinds.sh" "$ok..HEAD"; then echo "FAIL: mixed commit beside a sync merge accepted"; exit 1; fi
if "$here/check-commit-kinds.sh" "$synced..HEAD"; then echo "FAIL: mixed commit after a sync merge accepted"; exit 1; fi
git checkout -q -b ordinary "$ok"
git merge -q --no-ff -m "Merge branch 'upstream' into development" upstream
if "$here/check-commit-kinds.sh" "$ok..HEAD"; then echo "FAIL: mixed commit behind an ordinary merge accepted"; exit 1; fi
git checkout -q -b lookalike "$ok"
git merge -q --no-ff -m "$sync_subject (not quite)" upstream
if "$here/check-commit-kinds.sh" "$ok..HEAD"; then echo "FAIL: mixed commit behind a similar subject accepted"; exit 1; fi
echo "ok"
