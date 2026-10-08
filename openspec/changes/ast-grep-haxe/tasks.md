## 1. Setup

- [ ] 1.1 `extra/setup-serena.sh`: `@ast-grep/cli` at the pinned version into the user cache, one directory per version
- [ ] 1.2 `extra/setup-serena.sh`: `GeTechG/tree-sitter-haxe` at the pinned commit, built with `cc`, one directory per commit
- [ ] 1.3 `.ast-grep/ast-grep` and `.ast-grep/haxe.so` links, ignored through `info/exclude`
- [ ] 1.4 `sgconfig.yml`: the custom language `haxe` for `*.hx`

## 2. Documentation

- [ ] 2.1 `.github/infra-paths`: `sgconfig.yml`
- [ ] 2.2 `AGENTS.md`: `ast-grep`, Serena or a text search

## 3. Verification

- [ ] 3.1 Clean worktree, one command: `throw new $T($$$A)` over `std/` against a text search, every difference explained
- [ ] 3.2 The number of files with an `ERROR` node in `std/` and in `tests/`
