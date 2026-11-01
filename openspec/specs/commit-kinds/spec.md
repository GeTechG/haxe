# commit-kinds Specification

## Purpose
Keep every commit either upstreamable code or fork infrastructure, so an upstream PR is a cherry-pick of one task's code commits.

## Requirements

### Requirement: A commit is code or infrastructure, never both
Infrastructure is the set of paths listed in `.github/infra-paths` (paths of this fork, absent from upstream except `AGENTS.md`); every other path is code. CI SHALL reject any non-merge commit that touches both kinds, except a commit brought in by an upstream sync merge. An upstream sync merge is a merge commit whose subject is exactly `Merge branch 'development' of https://github.com/HaxeFoundation/haxe into development`; a commit it brings in is one reachable from its second parent. A range the check cannot resolve SHALL fail the check, never pass it unchecked.

#### Scenario: Mixed commit
- **WHEN** a commit changes `std/haxe/EntryPoint.hx` and `AGENTS.md`
- **THEN** the `commit-kinds` CI job fails and names the commit

#### Scenario: Single-kind commit
- **WHEN** a commit changes only code paths, or only infrastructure paths
- **THEN** the check passes

#### Scenario: Unresolvable range
- **WHEN** the check is given a range git cannot resolve, such as `refs/heads/missing..HEAD` or a push whose `before` commit no longer exists
- **THEN** the check fails

#### Scenario: Mixed commit from upstream
- **WHEN** the range holds an upstream sync merge, directly or inside a branch landed by an ordinary merge, and its second parent reaches a commit that changes `std/haxe/EntryPoint.hx` and `AGENTS.md`
- **THEN** the check does not reject that commit

#### Scenario: Mixed commit of ours beside an upstream sync
- **WHEN** the range holds an upstream sync merge and a mixed commit its second parent does not reach
- **THEN** the check fails and names the commit

#### Scenario: Mixed commit behind an ordinary merge
- **WHEN** a mixed commit reaches the range through a merge with any other subject
- **THEN** the check fails and names the commit

### Requirement: The check proves itself
`.github/scripts/check-commit-kinds-test.sh` SHALL build a throwaway repository with a mixed commit and fail unless the check rejects it, fail unless the check rejects an unresolvable range, fail unless the check accepts a mixed commit behind an upstream sync merge, and fail unless the check rejects a mixed commit behind an ordinary merge; CI runs it before the real check.

#### Scenario: The check stops rejecting mixed commits
- **WHEN** `check-commit-kinds.sh` accepts the mixed commit of the throwaway repository
- **THEN** the self-test fails, and the `commit-kinds` CI job fails before the real check runs

#### Scenario: The check accepts an unresolvable range
- **WHEN** `check-commit-kinds.sh` exits 0 on `refs/heads/missing..HEAD`
- **THEN** the self-test fails

#### Scenario: The check rejects upstream's commits
- **WHEN** `check-commit-kinds.sh` rejects a mixed commit behind an upstream sync merge
- **THEN** the self-test fails

#### Scenario: The check exempts an ordinary merge
- **WHEN** `check-commit-kinds.sh` accepts a mixed commit behind a merge with any other subject
- **THEN** the self-test fails

### Requirement: OpenSpec artifacts stay out of code commits
Proposals, tasks, spec deltas and archives live under `openspec/`, an infrastructure path, so they SHALL never share a commit with code.

#### Scenario: Change proposal alongside its implementation
- **WHEN** a task adds `openspec/changes/x/proposal.md` and changes `src/typing/typer.ml`
- **THEN** they land as two commits, and only the code commit is cherry-picked upstream
