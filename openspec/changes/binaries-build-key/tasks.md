## 1. Workflow

- [ ] 1.1 `binaries.yml`: full-history checkout, compute the build key, skip when `haxe-linux64-<key>.tar.gz` is published
- [ ] 1.2 Build the key commit with a 7-character revision in `haxe -version`; publish under the key without replacing an existing file
- [ ] 1.3 Drop `paths-ignore`; serialise runs

## 2. Documentation

- [ ] 2.1 `.github/infra-paths`: note that `extra/build-linux.sh` moves the build key
- [ ] 2.2 `AGENTS.md`: describe builds and the build key

## 3. Verification

- [ ] 3.1 The key rule on a throwaway history: code + infrastructure on top, `binaries.yml` edit, `extra/build-linux.sh` edit
- [ ] 3.2 The key of current `development` equals the one Sprout computes
