## Why

The answer of `display/references` may hold `null` among its locations: the lookup on `haxe.ui.components.Button` in a project with haxeui-core starts with `[null,{"file":…}]`, and an LSP client gets `null` in a list of `Location`. A type path which a macro builds by hand (`TPath({pack: [], name: "Button"})`) has no position. Every type hint is recorded as a usage of the type it names, so such a path becomes a usage without a position; the positions are sorted, it comes first, and a position without a file is written as `null`.

## What Changes

- A usage without a position is not collected: it is no place in a file, so there is nothing to answer with.
- Regression test in `tests/server`.

## Capabilities

### New Capabilities

None.

### Modified Capabilities
- `display-references`: every element of the answer is a location.

## Impact

- `src/context/display/statistics.ml`, `tests/server/src/cases/display/issues/ReferencesCandidates.hx`. Code: the build key moves.
- Shared by `display/references`, rename, `display/implementation` and `display/statistics`, which all read the same collected relations.
