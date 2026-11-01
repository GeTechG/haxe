## Why

Merging upstream fails `check-commit-kinds`, and with it CI on `development` (HX-24). Upstream keeps its own `AGENTS.md` and edits it together with code, while `AGENTS.md` is an infrastructure path here. `--no-merges` skips the merge commit but not the commits it brings in, so on `change/HX-23-upstream-sync` the check rejects three upstream commits (`27bd078e2`, `9c4ead5b6`, `3f9ebfd97`). They cannot be rewritten, and every later sync would hit the same wall. Those commits were never ours to divide into code and infrastructure.

## What Changes

- The check leaves out every commit reachable from the second parent of a merge whose subject is exactly `Merge branch 'development' of https://github.com/HaxeFoundation/haxe into development`, the subject of upstream syncs. All other commits are checked as before, including those of a branch brought in by an ordinary merge.
- The self-test proves both sides: a mixed commit behind a sync merge passes, a mixed commit behind an ordinary merge is rejected.
- The spec stops calling infrastructure paths "absent from upstream": `AGENTS.md` is one upstream also has.

The subject is the marker because it needs no network and no list to maintain. It is a convention, not a proof of origin: a merge given that subject by hand exempts what it brings in. That is acceptable for a check that guards against mistakes in a fork worked on solo. A sync under any other subject fails the check, the safe direction, and the subject is then fixed before pushing.

## Capabilities

### New Capabilities

None.

### Modified Capabilities
- `commit-kinds`: commits brought in by an upstream sync merge are not checked; infrastructure paths are no longer described as absent from upstream.

## Impact

- `.github/scripts/check-commit-kinds.sh`, `.github/scripts/check-commit-kinds-test.sh` — infrastructure: the build key does not move.
