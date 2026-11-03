## 1. Pinned CLI and skills

- [x] 1.1 Add `openspec/cli.pin` holding `1.16.0`; check: `openspec --version` equals it
- [x] 1.2 Generate the skills with `openspec init --tools claude,codex --profile custom` (propose, explore, continue, apply, update, ff, sync, archive, bulk-archive, verify) and commit `.claude/skills/openspec-*` and `.agents/skills/openspec-*` as generated; check: every `generatedBy` equals the pin, `git status` shows no other change
- [x] 1.3 AGENTS.md: the pin, how to raise it (global install, pin, regenerated skills in one commit), and that a change is created by `openspec new change`; check: read against the change

## 2. config.yaml rules

- [x] 2.1 Add `rules.specs`, `rules.tasks`, `operations.apply` and `operations.archive` (guidance pointing at AGENTS.md steps); check: `openspec instructions specs --change openspec-pinned-validation` shows the rules

## 3. Long requirements

- [x] 3.1 Rewrite the seven requirements through this change's delta specs; check: `openspec validate openspec-pinned-validation --strict` is clean

## 4. CI

- [x] 4.1 Add the `openspec` job to `.github/workflows/ci.yml` with the pinned CLI: strict validation, no `TBD` Purpose, `.openspec.yaml` in active changes, `generatedBy` equals the pin, no open non-`[human]` task in the archive; check: run its shell locally, and break each rule once in a scratch copy to see it fail
- [x] 4.2 Sync the specs and archive the change as the last commit; check: `openspec validate --all --strict` and `openspec validate --archived` are clean, the job passes on the archived tree

## Workflow follow-up

- Cross-review of the branch diff, commit-kinds checks, merge into `development`, CI green on the push
