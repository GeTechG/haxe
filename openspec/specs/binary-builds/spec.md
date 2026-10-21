# binary-builds Specification

## Purpose
Publish one compiler build per build key, so a consumer that bumps to an infrastructure-only commit keeps its compiler and its pinned checksum.

## Requirements

### Requirement: A build is named by its build key
The build key of a commit SHALL be the last commit in its history that touches a code path (any path not listed in `.github/infra-paths`) or the build recipe `extra/build-linux.sh`. The `Binaries` workflow SHALL publish the Linux x86_64 compiler of a pushed `development` head as `haxe-linux64-<key>.tar.gz` in the `builds` release, where `<key>` is the full SHA of the head's build key.

#### Scenario: Infrastructure commit on top of a code commit
- **WHEN** one push brings a code commit and, on top of it, a commit that changes only `AGENTS.md`
- **THEN** the build is published under the SHA of the code commit

#### Scenario: Build recipe changes
- **WHEN** a commit changes `extra/build-linux.sh`
- **THEN** that commit is the build key, although the path is infrastructure

#### Scenario: Workflow file changes
- **WHEN** a commit changes only `.github/workflows/binaries.yml`
- **THEN** the build key stays the same and no new file is published

### Requirement: The build is the key commit
The workflow SHALL build the tree of the key commit, so that `haxe -version` of the published compiler names the key commit by its 7-character abbreviated SHA.

#### Scenario: Version of a build published from an infrastructure head
- **WHEN** the head of the push is an infrastructure commit and its build key is `539502a6…`
- **THEN** the published compiler reports a version ending in `+539502a`

### Requirement: One file per key, never replaced
The workflow SHALL build nothing when a file for the key is already published, and SHALL NOT replace a published file: consumers pin its checksum and the build is not bit-reproducible. Runs for one key SHALL be serialised, so that two pushes with the same key yield one build; runs for different keys SHALL NOT cancel one another.

#### Scenario: Key already published
- **WHEN** a push to `development` has a build key whose file is in the `builds` release
- **THEN** the run ends after the lookup, without building or uploading

#### Scenario: Two pushes with one key in quick succession
- **WHEN** an infrastructure push arrives while the build of the preceding code push is running
- **THEN** its run waits for that build and then finds the file published

### Requirement: The release tag stays in place
The `Binaries` workflow SHALL NOT push or move the tag of the `builds` release: `GITHUB_TOKEN` may not move a ref across a change to `.github/workflows/`. A build SHALL be found by its file name in the release, never by the tag's position. When the release does not exist, the workflow SHALL create it, together with its tag at the key commit if the tag does not exist either.

#### Scenario: Build key after a workflow change
- **WHEN** a push to `development` brings a new build key and, since the commit the `builds` tag points to, a change to `.github/workflows/binaries.yml`
- **THEN** the build is published as `haxe-linux64-<key>.tar.gz` and the `builds` tag still points where it did before

#### Scenario: Release missing
- **WHEN** the `builds` release does not exist when a build is published
- **THEN** the workflow creates it and uploads the file
