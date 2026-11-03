## Context
OpenSpec 1.16.0 is installed globally on the maintainer's machine for Sprout and all forks. Its `init --tools claude,codex --profile custom` writes ten skills to `.claude/skills/openspec-*` (Claude Code wording) and `.agents/skills/openspec-*` (Codex wording, plus `.agents/skills/.openspec-target`). In this repository `.agents/skills/` is the real directory (`baton` lives there and `.claude/skills/baton` links to it), unlike Sprout where `.agents/skills` links to `.claude/skills`.

## Decisions
- **Both skill trees are committed as generated.** The two trees differ in how they name the next command (`/openspec-x` against `$openspec-x (Codex) or /openspec-x (other agents)`), so neither is a link to the other; regenerating is one `openspec update` and leaves no hand edits to keep.
- **The checks live in `ci.yml` itself**, as one `openspec` job beside `commit-kinds`. They are a few lines of shell around the pinned CLI; a script under `.github/scripts/` would be a path of its own to keep for no gain.
- **CI runs the pinned CLI through `npm exec --yes --package=@fission-ai/openspec@$(cat openspec/cli.pin)`**, never a global install, so CI and the pin cannot drift apart. The skill check compares every `generatedBy` with the pin, so a bump that forgets to regenerate fails.
- **Archived changes are checked by text, not by `openspec validate --archived`**: the rule is "no `- [ ]` without `[human]`", and `[human]` tasks stay open on purpose. Archived changes are not otherwise repaired (they predate `.openspec.yaml`).
- **Long requirements are rewritten through this change's delta specs** (MODIFIED, each with every scenario it had: OpenSpec refuses to move a scenario to another requirement, so details go into new scenarios of the same requirement rather than into split-off requirements), so the archive records the rewrite like any other spec change.

## Risks / Trade-offs
- CI depends on the npm registry for each run → the pinned version is immutable on npm; a registry outage fails the job, which is visible and retried.
- OpenSpec may tighten `--strict` in a later version → a bump runs the check locally first (AGENTS.md), and fixes land in the same change as the bump.
