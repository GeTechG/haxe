## Why

An agent working in a checkout of this fork cannot search code by its shape: `ast-grep` does not know Haxe without a grammar, and the checkout has neither the grammar nor a configuration. Serena finds a symbol and its references, a text search finds a string; neither finds "every `throw new X(...)`" or rewrites a pattern across `std/`.

## What Changes

- `extra/setup-serena.sh` also provisions `ast-grep`, before anything that needs the compiler build or opam:
  - the `ast-grep` binary from the npm package `@ast-grep/cli` at the version pinned in the script (npm is already a requirement of the command), one cache directory per version;
  - the Haxe grammar `GeTechG/tree-sitter-haxe` at the commit pinned in the script, built with the system C compiler from the sources the repository commits, one cache directory per commit;
  - both linked into the checkout as `.ast-grep/ast-grep` and `.ast-grep/haxe.so`, ignored through the clone's `info/exclude`.
- `sgconfig.yml` at the root registers the grammar as the custom language `haxe` for `*.hx`.
- `AGENTS.md`: when to take `ast-grep`, when Serena, when a text search.
- `.github/infra-paths`: `sgconfig.yml` is infrastructure.

## Capabilities

### New Capabilities
- `structural-search`: what the setup command provisions for `ast-grep`, where it takes the binary and the grammar from, and what a search over the sources is expected to find.

### Modified Capabilities

None.

## Impact

- New: `sgconfig.yml`. Changed: `extra/setup-serena.sh`, `AGENTS.md`, `.github/infra-paths`. All infrastructure: the build key does not move.
- Per checkout, untracked: `.ast-grep/`.
- User cache `${XDG_CACHE_HOME:-~/.cache}/haxe-dev`: `ast-grep/<version>`, `tree-sitter-haxe/<commit>`.
- The command now also requires `cc`.
- Not part of this change: lint rules and a stage in the checks; errors of the grammar itself (project TSHX).
