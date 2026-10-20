## 1. Generator

- [x] 1.1 `keywords` in `hl2c.ml` lists the macros of the C standard library headers the HL/C output includes, the names compilers predefine, and the unprefixed macros of `hl.h`/`hlc.h`
- [x] 1.2 Every place HL/C writes a field name goes through `ident`: the prefetch of a field (`$prefetch`) as well

## 2. Verification

- [x] 2.1 `tests/misc/hlc/projects/reservedKeywords`: a class with a static and an instance field `USHRT_MAX` and `INT_MAX`, and a field under each listed name, compiles through HL/C; `$prefetch` of a field named `isfinite`
- [x] 2.2 The generated C of that test builds with `cc` against HashLink and runs: fails to build on the compiler before the change, builds and runs after
