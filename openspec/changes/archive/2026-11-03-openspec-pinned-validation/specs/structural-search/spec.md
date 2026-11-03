## MODIFIED Requirements

### Requirement: The setup command provisions ast-grep for Haxe
`extra/setup-serena.sh` SHALL, in a fresh checkout or worktree and without further steps, leave `.ast-grep/ast-grep` able to search `*.hx` files by code shape as the language `haxe`, configured by the tracked `sgconfig.yml` at the root. What it leaves in the checkout SHALL be untracked and ignored, without changing a code path. Past the tool checks `serena-setup` states, it SHALL do so before it takes the compiler build.

#### Scenario: Fresh worktree
- **WHEN** the command has run once in a new worktree
- **THEN** `.ast-grep/ast-grep run -p 'throw new $T($$$A)' -l haxe std` lists the `throw new` expressions of `std/` that a text search finds outside comments and string literals

#### Scenario: Checkout left clean
- **WHEN** the command has run in a checkout without local changes
- **THEN** `git status` shows no change

#### Scenario: Build key without a build
- **WHEN** `HEAD` holds a code commit whose build is not published
- **THEN** the command still fails as `serena-setup` states, and `.ast-grep/ast-grep` works

#### Scenario: Required tool missing
- **WHEN** `opam` is not installed
- **THEN** the command fails before it writes anything, `.ast-grep/` included
