# serena-setup Specification

## Purpose
Give an agent symbol navigation in any checkout of this fork — the compiler in OCaml, the standard library in Haxe — from one command that takes the compiler from the fork's own builds and never substitutes another.

## Requirements

### Requirement: One command wires Serena to a checkout
`extra/setup-serena.sh` SHALL, in a fresh checkout or worktree and without further steps, leave Serena able to find the references to a symbol of the compiler (`src/`, OCaml) and to a symbol of the standard library (`std/`, Haxe). It SHALL be safe to run again, and SHALL keep what it downloads and builds in `${XDG_CACHE_HOME:-~/.cache}/haxe-dev`, shared between checkouts. What it leaves in the checkout SHALL be untracked and ignored, without changing a code path.

#### Scenario: Fresh worktree
- **WHEN** the command has run once in a new worktree and Serena is started there
- **THEN** a reference lookup on a symbol of `src/` and one on a symbol of `std/` return the places a text search finds

#### Scenario: Second run
- **WHEN** the command runs again in the same checkout
- **THEN** it downloads and builds nothing that is already in the cache, and regenerates the display configuration

### Requirement: The Haxe compiler is the fork's build for the checkout's build key
The command SHALL compute the build key of `HEAD` by the rule of `binary-builds`, take `haxe-linux64-<key>.tar.gz` from the `builds` release into the cache (one directory per key) and link it as `.haxe`. When the release has no file for the key, the command SHALL fail and say that the key has no build yet; it SHALL NOT fall back to another build or to a compiler found on the machine.

#### Scenario: Key without a build
- **WHEN** `HEAD` holds a code commit whose build is not published
- **THEN** the command exits non-zero, names the key, and leaves `.haxe` and the Serena configuration as they were

#### Scenario: Infrastructure commit on top
- **WHEN** `HEAD` is an infrastructure commit on top of a code commit that has a build
- **THEN** `.haxe` points at the build of that code commit

### Requirement: The Haxe language server is built from a pinned commit
The command SHALL build `vshaxe/haxe-language-server` from source at the commit pinned in the script, into a cache directory named after that commit, and point Serena at it: the published vshaxe server needs `--wait stdio`, which Haxe 5 does not have. The server SHALL run with `.haxe` first on `PATH` and with the checkout's `std/` as the standard library.

#### Scenario: Server already built
- **WHEN** the cache holds a build of the pinned commit
- **THEN** the command reuses it

### Requirement: The display configuration names the modules to type
The command SHALL generate the display configuration by walking `std/`: one target, and one line per module — dot path, no `import.hx` — for every module that types under that target, since a display server that is given no modules types nothing and answers reference lookups in part. It SHALL hold nothing but the target, class paths, defines, warning switches and modules (no `-lib`, no `--macro`), and the command SHALL fail unless the compiler accepts the whole configuration.

#### Scenario: Module of another platform
- **WHEN** a module of `std/` does not type under the target of the display configuration
- **THEN** it is left out, and the configuration compiles with exit code 0

#### Scenario: New file
- **WHEN** a module is added to `std/` and the command runs again
- **THEN** the module is in the display configuration

### Requirement: OCaml navigation comes from an opam switch, never from an installed opam
The command SHALL use the checkout's `_opam` switch when there is one, and otherwise link `_opam` to a switch in the cache shared between checkouts; it SHALL install the compiler's dependencies and `ocaml-lsp-server` into that switch and build `@ocaml-index`. Without `opam` on `PATH` it SHALL fail with a message that says what to install, and SHALL NOT install `opam` or system packages itself.

#### Scenario: No opam
- **WHEN** `opam` is not on `PATH`
- **THEN** the command exits non-zero with a message that names `opam`, before it writes anything

### Requirement: Serena's local project file is generated, a foreign one is kept
The wiring SHALL live in `.serena/project.local.yml`, which git ignores, and carry a generator mark. The command SHALL create a minimal `.serena/project.yml` first when there is none (Serena overwrites the local file when it has to generate the project file), and SHALL refuse to overwrite a `project.local.yml` that has content and no generator mark.

#### Scenario: Someone's own overrides
- **WHEN** `.serena/project.local.yml` holds settings and no generator mark
- **THEN** the command exits non-zero and leaves the file as it is
