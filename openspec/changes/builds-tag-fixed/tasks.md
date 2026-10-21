## 1. Workflow

- [ ] 1.1 The publish step of `binaries.yml` drops `git push -f origin "$KEY:refs/tags/builds"`; when the `builds` release is missing it is created with `--target "$KEY"`, which creates the tag only if it does not exist
- [ ] 1.2 The comment on the publish step says the tag stays in place and why

## 2. Verification

- [ ] 2.1 No step of `binaries.yml` pushes a ref
- [ ] 2.2 The workflow parses as YAML
