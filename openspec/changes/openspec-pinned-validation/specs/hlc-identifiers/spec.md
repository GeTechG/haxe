## MODIFIED Requirements

### Requirement: A Haxe name that is a C macro is renamed in HL/C
HL/C SHALL write a Haxe field, type or global whose name is a C keyword, a macro defined by the headers its output includes, a name the C compiler predefines in its default mode, or a name that starts with `__`, as `_hx_<name>`, everywhere it writes that name, so that the C compiles and the program behaves as on the other targets. Any other name is written as it is.

#### Scenario: A field named like a macro of limits.h
- **WHEN** a class has a static field and an instance field named `USHRT_MAX`, and one named `INT_MAX`, and is compiled with `-hl main.c`
- **THEN** the generated C names them `_hx_USHRT_MAX` and `_hx_INT_MAX`
- **AND** it builds with a C compiler against HashLink, and the program reads and writes the fields as on the other targets

#### Scenario: A name that is not a macro
- **WHEN** a field is named `count`
- **THEN** HL/C writes it as `count`

#### Scenario: Headers that count
- **WHEN** a name is a macro of a C standard library header the output includes, of `hl.h` or of `hlc.h`
- **THEN** HL/C renames it, except a name of `hl.h` or `hlc.h` prefixed `HL_`, `hl_` or `_`, which is left to the program

#### Scenario: A name the C compiler predefines
- **WHEN** a field is named `linux`, `unix` or `i386`
- **THEN** HL/C writes it as `_hx_linux`, `_hx_unix` or `_hx_i386`

#### Scenario: Macros of other platform headers
- **WHEN** a name is a macro only of a platform header such as `windows.h` or an SDL header
- **THEN** this requirement does not cover it
