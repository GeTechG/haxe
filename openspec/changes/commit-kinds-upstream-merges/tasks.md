## 1. Check

- [ ] 1.1 `check-commit-kinds.sh` finds the merges in the range whose subject is exactly the upstream sync subject, and excludes what is reachable from their second parents
- [ ] 1.2 A range git cannot resolve still fails the check

## 2. Verification

- [ ] 2.1 `check-commit-kinds-test.sh`: a mixed commit behind a sync merge passes, also when the branch holding the sync merge lands by an ordinary merge
- [ ] 2.2 `check-commit-kinds-test.sh`: a mixed commit behind an ordinary merge, and one of ours beside a sync merge, are rejected
- [ ] 2.3 The self-test passes, and fails against the check before the change
- [ ] 2.4 The new check passes on `origin/development..origin/change/HX-23-upstream-sync`, which the old check rejects
