## 1. Generator

- [ ] 1.1 `keywords` in `hl2c.ml` lists the macros of the C standard library headers the HL/C output includes, the names compilers predefine, and the unprefixed macros of `hl.h`/`hlc.h`

## 2. Verification

- [ ] 2.1 `tests/misc/hlc/projects/reservedKeywords`: a class with a static and an instance field `USHRT_MAX` and `INT_MAX`, and a field under each listed name, compiles through HL/C
- [ ] 2.2 The generated C of that test builds with `cc` against HashLink and runs: fails to build on the compiler before the change, builds and runs after
