## ADDED Requirements

### Requirement: The release tag stays in place
The `Binaries` workflow SHALL NOT push or move the tag of the `builds` release: `GITHUB_TOKEN` may not move a ref across a change to `.github/workflows/`. A build SHALL be found by its file name in the release, never by the tag's position. When the release does not exist, the workflow SHALL create it, together with its tag at the key commit if the tag does not exist either.

#### Scenario: Build key after a workflow change
- **WHEN** a push to `development` brings a new build key and, since the commit the `builds` tag points to, a change to `.github/workflows/binaries.yml`
- **THEN** the build is published as `haxe-linux64-<key>.tar.gz` and the `builds` tag still points where it did before

#### Scenario: Release missing
- **WHEN** the `builds` release does not exist when a build is published
- **THEN** the workflow creates it and uploads the file
