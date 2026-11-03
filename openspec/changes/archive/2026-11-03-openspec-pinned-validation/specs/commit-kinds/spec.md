## MODIFIED Requirements

### Requirement: A commit is code or infrastructure, never both
Infrastructure is the set of paths listed in `.github/infra-paths` (paths of this fork, absent from upstream except `AGENTS.md`); every other path is code. CI SHALL reject any non-merge commit that touches both kinds, except one reachable from the second parent of an upstream sync merge: a merge whose subject is exactly `Merge branch 'development' of https://github.com/HaxeFoundation/haxe into development`. A range the check cannot resolve SHALL fail the check.

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
