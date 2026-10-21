## Why

The `Binaries` workflow moves the `builds` tag to every new build key with `git push -f` and `GITHUB_TOKEN`. GitHub refuses that push once the history between the old and the new tag position adds or changes a file under `.github/workflows/` ("refusing to allow a GitHub App to create or update workflow … without `workflows` permission"), and `GITHUB_TOKEN` cannot be given that permission. The first such push would fail the publish step after the build, and no file would be published for the key (HX-19).

Nothing reads the tag's position: consumers find a build by its file name, `haxe-linux64-<key>.tar.gz`, in the `builds` release. The tag exists only because a release needs one.

## What Changes

- The workflow no longer pushes the `builds` tag. The tag stays where it is; when the release has to be created, the release API creates the tag at the key commit.
- The `binary-builds` spec states that the release's tag is not moved, and that a build is found by its file name only.

A personal access token with `workflow` scope was the other option: it would keep the tag moving, at the price of a long-lived secret with write access to workflows, for a tag position nobody uses.

## Capabilities

### New Capabilities

None.

### Modified Capabilities
- `binary-builds`: the `builds` release keeps its tag in place; publishing a build never moves it.

## Impact

- `.github/workflows/binaries.yml` — infrastructure: the build key does not move.
