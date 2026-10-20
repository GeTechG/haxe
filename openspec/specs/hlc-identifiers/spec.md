# hlc-identifiers Specification

## Purpose
Say which Haxe names HL/C writes to C under another name, so that the generated C compiles whatever the program calls its fields, types and globals.

## Requirements

### Requirement: A Haxe name that is a C macro is renamed in HL/C
HL/C SHALL NOT write a Haxe field, type or global to C under a name that is a C keyword or a macro defined by the headers its output includes: the C standard library headers included by the output, `hl.h` or `hlc.h` (except the names prefixed `HL_`, `hl_` or `_`, which are left to the program), or a name the C compiler predefines in its default mode (`linux`, `unix`, `i386`). Such a name SHALL be written as `_hx_<name>`, everywhere HL/C writes it, so that the C compiles and the program behaves as on the other targets. A name that starts with `__` is renamed the same way. Macros of other platform headers (`windows.h`, SDL) are not covered.

#### Scenario: A field named like a macro of limits.h
- **WHEN** a class has a static field and an instance field named `USHRT_MAX`, and one named `INT_MAX`, and is compiled with `-hl main.c`
- **THEN** the generated C names them `_hx_USHRT_MAX` and `_hx_INT_MAX`
- **AND** it builds with a C compiler against HashLink, and the program reads and writes the fields as on the other targets

#### Scenario: A name that is not a macro
- **WHEN** a field is named `count`
- **THEN** HL/C writes it as `count`
