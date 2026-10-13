## ADDED Requirements

### Requirement: An operating system error in a sys call is a Haxe exception
When the operating system refuses a call of the `sys` API made by a program on eval — under `--run`, `--interp` or in a macro — the call SHALL throw a Haxe exception that the program can catch with `catch (e:haxe.Exception)`. The error SHALL NOT end the compiler with the OCaml exception (`Unix.Unix_error(…)`, `Failure`) instead. This covers `sys.net.Socket`, `sys.io.Process`, `Sys.putEnv` with a value and `Sys.systemName`; removing a variable (`Sys.putEnv(name, null)`) is not covered, its result is not looked at.

An exception the program does not catch ends the run with an error, like any other uncaught exception.

#### Scenario: shutdown of a socket that is not connected
- **WHEN** a program on eval calls `shutdown(true, true)` on a `sys.net.Socket` that is not connected, inside `try … catch (e:haxe.Exception)`
- **THEN** the `catch` block runs, or the call returns, as the system decides
- **AND** the program goes on and the compiler exits with code 0

#### Scenario: Reading from a socket that is not connected
- **WHEN** the program reads from the `input` of a `sys.net.Socket` that is not connected
- **THEN** it gets an exception it can catch

#### Scenario: Writing to the stdin of a closed process
- **WHEN** the program writes to the `stdin` of a `sys.io.Process` after `close()`
- **THEN** it gets an exception it can catch
