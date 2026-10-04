# haxe — agent guide

Independent fork of `HaxeFoundation/haxe` (the Haxe compiler and standard library). Its consumers pin it by commit; they do not dictate how it is worked on. This file is the source of truth here; `.github/copilot-instructions.md` (from upstream) describes the code layout, build and tests.

## Workflow
No pull requests: this fork is worked on solo. Work lives on branches and lands on `development` by rebase or merge; the only mandatory gate is green checks (see *Checks*) on the exact tree that lands. Work is scheduled by baton — load the `/baton` skill before filing or picking up an issue, or changing an issue's status, labels, `footprint` or blockers.

An issue runs the same seven steps, in order:

1. **OpenSpec change.** Branch `change/<ISSUE-KEY>-<openspec-name>` from `origin/development` — one task, one branch — and write the change under `openspec/changes/`. Skip the OpenSpec change — here and in step 3 — when the work is mechanical, i.e. nothing the project history needs a record of (docs, renames, config, a bug fix that returns behaviour to what was intended). A fix that changes the intended behaviour, or anything `openspec/specs/` describes, is not mechanical — the change is mandatory. A skip is never silent: the report on the issue carries the line `OpenSpec skipped: <reason>`. The other steps stay. An issue labeled `gate:spec` stops here: push the artifacts, post a short plan on the issue, add `needs-human`; continue once the maintainer swaps it for `spec:approved`.
2. **Implement** the tasks.
3. **Test.** Verify the implementation against the change, then sync its specs and archive it as the **last commit of the branch** (never a separate push to `development`), rebase onto current `development` and run the checks. Unless the task is trivial (mechanical, or a few obvious lines), finish with a cross-review of the whole branch diff before the checks — `/ai-brainstorm:ai-review`, a judge from another model family — and fix or rebut its findings until clean.
4. **Human QA — only if the change has it.** Steps only a human can do are written `- [ ] N.M [human] …` in `tasks.md`; agents never tick them. If there are any, post them on the issue as a checklist a human can follow cold, add `needs-human` and stop; continue once the maintainer removes the label. No `[human]` tasks → skip.
5. **Merge** into `development`: `git merge --ff-only` for a single commit or a short linear series, `git merge --no-ff` for a multi-commit change. Push `development`. If `development` moved since the checks ran, rebase and run them again first.
6. **Clean up**: delete the branch (local and remote) and its worktree.
7. **Set the issue done.**

The maintainer decides architecture and end-user behaviour, nothing else — steps 1 (`gate:spec`) and 4 are the only points where an agent waits for a human. Work without an issue: mechanical edits may go straight to `development`.

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

## Builds
`.github/workflows/binaries.yml` publishes a Linux x86_64 compiler for every push to `development`, as `haxe-linux64-<key>.tar.gz` in the single `builds` release. `<key>` is the **build key**: the last commit in the history that touches code or the build recipe `extra/build-linux.sh` — the one infrastructure path that changes the compiler. An infrastructure push keeps the key and builds nothing; `haxe -version` names the key commit. Consumers find a build by computing the same key, and pin the checksum of the file: a published file is never replaced, and the rule changes only through `openspec/specs/binary-builds`.

## Specs
`openspec/` holds this fork's own specs (`openspec/specs/`). Behaviour or rule changes go through `openspec/changes/`.
