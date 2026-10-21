## Why

`check-commit-kinds.sh` loops over `$(git rev-list --no-merges "$range")`. When git cannot resolve the range (`refs/heads/missing..HEAD`, or a push whose `before` SHA is gone after a force-push), git prints a fatal error, but `set -e` ignores a failing command substitution in a `for` list: the loop is empty and the script exits 0. The CI gate passes without checking anything (HX-18).

## What Changes

- The check takes the commit list in its own assignment, so an unresolvable range fails the check.
- The self-test asserts that an unresolvable range fails.

## Capabilities

### New Capabilities

None.

### Modified Capabilities
- `commit-kinds`: a range the check cannot resolve fails it.

## Impact

- `.github/scripts/check-commit-kinds.sh`, `.github/scripts/check-commit-kinds-test.sh` — infrastructure: the build key does not move.
