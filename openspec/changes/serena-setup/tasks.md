## 1. Setup command

- [x] 1.1 `extra/setup-serena.sh`: compiler build of the checkout's build key into the user cache, `.haxe` symlink; fail when the key has no build
- [x] 1.2 Language server from source at the pinned commit, one cache directory per commit
- [x] 1.3 Display configuration: every `std/` module that types under the target, checked by compiling it
- [x] 1.4 OCaml: opam switch (own or shared), dependencies, `ocaml-lsp-server`, `@ocaml-index`; fail without `opam`
- [x] 1.5 `.serena/project.yml` when missing, `.serena/project.local.yml` unless it is someone else's

## 2. Wiring and documentation

- [x] 2.1 `.mcp.json`, `.codex/config.toml`
- [x] 2.2 `.github/infra-paths`: the new files
- [x] 2.3 `AGENTS.md`: navigation, when to run the command again

## 3. Verification

- [ ] 3.1 Fresh worktree, one command: Serena finds the references to a symbol of `src/` and to a symbol of `std/`; both lists compared with a text search
- [ ] 3.2 Refusals: no `opam`, no build for the key, a foreign `project.local.yml`
