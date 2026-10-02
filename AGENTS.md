# haxe — agent guide

Independent fork of `HaxeFoundation/haxe` (the Haxe compiler and standard library). Its consumers pin it by commit; they do not dictate how it is worked on. This file is the source of truth here; `.github/copilot-instructions.md` (from upstream) describes the code layout, build and tests.

## Branches and delivery
- One task — one branch, cut from `development`.
- No pull requests: this fork is worked on solo. When the task is done, run the checks on its branch, then rebase it onto `development` and fast-forward `development` to it (merge instead when a rebase is impractical) and push `development`.

## Commits
- Every commit is **code** (compiler and library sources, tests, upstream metadata — anything that exists upstream) or **infrastructure** (the paths listed in `.github/infra-paths`, absent from upstream: this file, `openspec/`, our CI and scripts). Never both — CI rejects a mixed commit.
- OpenSpec artifacts (proposal, tasks, specs, archive) never share a commit with code.
- Code commit messages are written as for upstream `HaxeFoundation/haxe`: `[area] Imperative summary` where an area applies (`[js]`, `[server]`, `[hlc]`), no mention of consumers or their paths.
- An upstream PR is a cherry-pick of one task's code commits; keep them self-contained — they must build and pass tests without the infrastructure commits.
- Changing the list of infrastructure paths is an infrastructure commit.

## Checks
Before pushing:
- `bash .github/scripts/check-commit-kinds-test.sh` — self-test of the commit-kind check.
- `bash .github/scripts/check-commit-kinds.sh origin/development..HEAD` — the check on your branch.
- For code commits: build (`make haxe`) and run the tests the change touches, as described in `.github/copilot-instructions.md` and `tests/README.md`; a bug fix comes with a regression test. The full matrix runs in `.github/workflows/main.yml`.

## Specs
`openspec/` holds this fork's own specs (`openspec/specs/`). Behaviour or rule changes go through `openspec/changes/`.
