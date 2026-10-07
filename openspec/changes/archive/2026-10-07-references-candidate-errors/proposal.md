## Why

`display/references` on a member with a common name (`get`, `set`) answers `Compiler error` instead of a list in a project whose class paths hold library code. To find usages, the compiler types every known file that mentions the name. Such a candidate may not type on its own — a module meant for macros only, a class built by a macro that fails outside a full build, a file for another target — and the same configuration compiles cleanly, because a build never loads it. The first exception of a candidate stops its typing queue; what is left in the queue runs later, while the usages are collected, and its next exception ends the request.

## What Changes

- A candidate file that fails to type no longer fails the lookup: its typing queue is run to the end, each failure dropped, before the next candidate is loaded.
- Side effect of the same fix: usages inside the part of a failing candidate that does type are found, and a failing candidate no longer makes the one loaded after it fail.
- Regression test in `tests/server`.

## Capabilities

### New Capabilities
- `display-references`: what a reference lookup answers when files it has to type on the way do not compile.

### Modified Capabilities

None.

## Impact

- `src/context/display/syntaxExplorer.ml`, `tests/server/src/cases/display/issues/ReferencesBrokenCandidate.hx`. Code: the build key moves.
- Shared by `display/references`, rename and `display/implementation`, which all go through the same candidate search.
