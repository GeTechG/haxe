## 1. Fix

- [x] 1.1 `Statistics.collect_statistics`: do not record a relation whose position is not a place in a file

## 2. Verification

- [x] 2.1 Server test `cases.display.issues.ReferencesCandidates.testTypeHintWithoutPosition`: fails on the build before the fix, passes after
- [x] 2.2 The server tests show no other difference from the build before the fix
- [x] 2.3 The lookup of HX-8 (`haxe.ui.components.Button` in Sprout) answers with the same locations as before, without the `null`
