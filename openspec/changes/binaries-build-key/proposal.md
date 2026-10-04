## Why

Consumers look a compiler build up by its **build key** — the last commit in history that touches code or the build recipe `extra/build-linux.sh` — so that a bump to an infrastructure-only commit keeps the compiler and its checksum. The `Binaries` workflow names the file after the head of the push instead. The two agree only when the head is a code commit: a push of a code commit with an infrastructure commit on top publishes under a SHA nobody looks up, an edit of `binaries.yml` publishes a second file for an unchanged compiler, and the workflow's `paths-ignore` repeats `.github/infra-paths` by hand.

## What Changes

- The workflow computes the build key from the history (full checkout), builds the key commit and publishes `haxe-linux64-<key>.tar.gz`; `haxe -version` of the build names the key commit.
- A push whose key already has a file builds nothing. This replaces `paths-ignore`: every push to `development` starts the workflow, an infrastructure-only one ends at the lookup.
- A published file is never replaced (consumers pin its checksum, and the build is not bit-reproducible); runs are serialised so two pushes with one key do not both build.
- `extra/build-linux.sh` stays in `.github/infra-paths`: it does not exist upstream, so it cannot be code. It is the one infrastructure path that moves the key; the exception is written down next to the list and in the spec.

## Capabilities

### New Capabilities
- `binary-builds`: what the build key is, and how the `Binaries` workflow names, builds and publishes compiler builds.

### Modified Capabilities

None.

## Impact

- `.github/workflows/binaries.yml`, `.github/infra-paths` (comment only), `AGENTS.md`.
- Consumers that compute the key themselves (Sprout's `tools/setup-haxe.sh`) need no change: the rule is the one they already use.
- Files already in the `builds` release under head SHAs stay; nothing looks them up any more.
