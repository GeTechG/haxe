## Why

An agent working in a checkout of this fork has no symbol navigation: Serena is not wired up, and neither of its language servers works here out of the box. The published vshaxe language server only talks `--wait stdio`, which Haxe 5 dropped; a display server that is given no modules types nothing, so reference lists come back partial without saying so; and `ocaml-lsp` needs an opam switch that holds the compiler's dependencies.

## What Changes

- `extra/setup-serena.sh`: one command per checkout that wires Serena to both languages.
  - **OCaml (`src/`)**: `ocaml-lsp` from an opam switch — the checkout's own `_opam`, or a switch shared between checkouts in the user cache and linked as `_opam` — with the compiler's dependencies, and the `@ocaml-index` build cross-file references need. No `opam`: an error that says so, nothing is installed in its place.
  - **Haxe (`std/`)**: the fork's own published build for the build key of the checkout (`haxe-linux64-<key>.tar.gz` of the `builds` release) in the user cache, linked as `.haxe`. No build for the key: an error that says so, never another build.
  - The language server is `vshaxe/haxe-language-server` built from source at a pinned commit, one cache directory per commit.
  - A generated display configuration that names every `std/` module that types under its target, and is proven by compiling it.
  - `.serena/project.local.yml` carries the wiring; one that the command did not write is left alone.
- `.mcp.json` and `.codex/config.toml` start Serena for Claude Code and Codex.
- `AGENTS.md`: what navigates what, and when to run the command again.
- `.github/infra-paths`: the new files are infrastructure.

## Capabilities

### New Capabilities
- `serena-setup`: what the setup command provisions, where it takes the compiler and the language servers from, and what it refuses to do.

### Modified Capabilities

None.

## Impact

- New: `extra/setup-serena.sh`, `.mcp.json`, `.codex/config.toml`. Changed: `AGENTS.md`, `.github/infra-paths`.
- All of them are infrastructure: the build key does not move.
- Per checkout, untracked: `.haxe`, `_opam` (both ignored through the clone's `info/exclude`, so that no code path changes) and `.serena/`.
- User cache `${XDG_CACHE_HOME:-~/.cache}/haxe-dev`: compiler builds per key, the language server per commit, the opam switch per OCaml version.
- Tests (`tests/`) are not in the display configuration: they need `utest`, which a fresh checkout does not have. Symbols of a test file are still listed; references from tests are not.
