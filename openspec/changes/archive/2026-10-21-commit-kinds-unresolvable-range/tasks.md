## 1. Check

- [x] 1.1 `check-commit-kinds.sh` assigns `git rev-list --no-merges "$range"` to a variable before the loop, so `set -e` stops on an unresolvable range

## 2. Verification

- [x] 2.1 `check-commit-kinds-test.sh` fails unless the check rejects `refs/heads/missing..HEAD`
- [x] 2.2 The self-test passes, and fails against the check before the change
