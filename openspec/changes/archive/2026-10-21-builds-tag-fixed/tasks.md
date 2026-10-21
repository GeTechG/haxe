## 1. Workflow

- [x] 1.1 The publish step of `binaries.yml` drops `git push -f origin "$KEY:refs/tags/builds"`; when the `builds` release is missing it is created with `--target "$KEY"`, which creates the tag only if it does not exist
- [x] 1.2 The comment on the publish step says the tag stays in place and why

## 2. Verification

- [x] 2.1 No step of `binaries.yml` pushes a ref
- [x] 2.2 The workflow parses as YAML
