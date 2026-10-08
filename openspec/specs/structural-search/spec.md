# structural-search Specification

## Purpose
Give an agent search and rewrite by code shape over the Haxe sources in any checkout of this fork — `ast-grep` on a Haxe grammar — from the same one command as symbol navigation, with the binary and the grammar pinned.

## Requirements

### Requirement: The setup command provisions ast-grep for Haxe
`extra/setup-serena.sh` SHALL, in a fresh checkout or worktree and without further steps, leave `.ast-grep/ast-grep` able to search `*.hx` files by code shape as the language `haxe`, configured by the tracked `sgconfig.yml` at the root. What it leaves in the checkout SHALL be untracked and ignored, without changing a code path. The command checks its required tools first, as `serena-setup` states (without `opam` it fails before it writes anything, this step included). Past those checks this step SHALL run before the compiler build is taken, so a build key without a build does not hold it back.

#### Scenario: Fresh worktree
- **WHEN** the command has run once in a new worktree
- **THEN** `.ast-grep/ast-grep run -p 'throw new $T($$$A)' -l haxe std` lists the `throw new` expressions of `std/` that a text search finds outside comments and string literals

#### Scenario: Build key without a build
- **WHEN** `HEAD` holds a code commit whose build is not published
- **THEN** the command still fails as `serena-setup` states, and `.ast-grep/ast-grep` works

### Requirement: The binary and the grammar are pinned and cached per pin
The command SHALL take the `ast-grep` binary from the npm package `@ast-grep/cli` at the exact version pinned in the script, and build the grammar from `GeTechG/tree-sitter-haxe` at the commit pinned in the script with the system C compiler, from the generated sources that repository commits. Each SHALL live in `${XDG_CACHE_HOME:-~/.cache}/haxe-dev`, shared between checkouts, in a directory named after its pin; an `ast-grep` found on the machine SHALL NOT be used.

#### Scenario: Second run
- **WHEN** the cache holds the pinned version and the pinned commit
- **THEN** the command downloads and builds neither, and points the links at them

#### Scenario: Pin moved
- **WHEN** the version or the commit in the script changes and the command runs again
- **THEN** the new one is installed next to the old one, and the links of this checkout point at the new one
