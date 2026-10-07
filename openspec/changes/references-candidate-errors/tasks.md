## 1. Fix

- [x] 1.1 `SyntaxExplorer.explore_uncached_modules`: run the typing queue of a candidate to the end, dropping each failure, also when the module itself fails to load

## 2. Verification

- [x] 2.1 Server test `cases.display.issues.ReferencesBrokenCandidate`: fails on the build before the fix, passes after
- [x] 2.2 The `cases.display` server tests pass
- [x] 2.3 The lookup of HX-6 (haxeui-heaps with heaps and haxeui-core, `TileCache.get`) answers with a list
