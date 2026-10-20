## Why

HL/C (`-hl main.c`) writes a Haxe field, type or global under its own name. `hl2c.ml` (`keywords` / `ident`) renames C keywords, but not the macros of the headers the output includes: a field named like a macro of `<limits.h>`, `<stdint.h>`, `<math.h>`, … is replaced by the preprocessor and the C does not compile (HX-17, found in SPR-230: `box2D.common.B2Settings.USHRT_MAX`, Android NDK r27d, `USHRT_MAX` → `(__SHRT_MAX__ * 2 + 1)`, `error: expected identifier`).

## What Changes

- The names HL/C renames (to `_hx_<name>`, as it does for keywords) also cover:
  - the macros of the C standard library headers the output includes, directly or through `hl.h`/`hlc.h`: `<limits.h>`, `<stdint.h>`, `<stddef.h>`, `<stdbool.h>`, `<stdlib.h>`, `<stdio.h>`, `<wchar.h>`, `<stdarg.h>`, `<signal.h>`, `<setjmp.h>`, `<math.h>`, `<float.h>`, `<errno.h>` — as ISO C names them, with the POSIX ones the GNU and Bionic headers expose by default (`M_PI`, `PATH_MAX`, `PAGE_SIZE`, …);
  - the names compilers predefine in their default GNU mode (`linux`, `unix`, `i386`);
  - the macros of `hl.h` and `hlc.h` that have no `HL_`/`hl_`/`_` prefix (`IS_64`, `USTR`, `EXPORT`, …).
- A name not in the list is written as before; a renamed name is renamed everywhere HL/C writes it, so the program behaves the same.
- Regression test in `tests/misc/hlc/projects/reservedKeywords`.

## Capabilities

### New Capabilities
- `hlc-identifiers`: which Haxe names HL/C writes to C under another name.

### Modified Capabilities

None.

## Impact

- `src/generators/hl2c.ml`, `tests/misc/hlc/projects/reservedKeywords/`. Code: the build key moves.
- The C name of a Haxe field, type or global in the list changes (`_hx_USHRT_MAX`); native code that reached such a name by hand in the generated C has to follow. It could not compile before.
- Macros of platform headers outside the C standard library (`windows.h`, SDL) are not covered.
