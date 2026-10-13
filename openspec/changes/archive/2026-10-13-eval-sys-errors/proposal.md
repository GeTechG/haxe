## Why

`sys.net.Socket.shutdown` on eval fails past every `catch`: a socket that is not connected makes the compiler print `Unix.Unix_error(Unix.ENOTCONN, "shutdown", "")` and exit with code 1, where the other targets and the other socket methods throw (HX-16, found in SPR-163).

The cause is one pattern in `src/macro/eval/evalStdLib.ml`: `catch_unix_error f arg` guards the application of `f` to one argument, and `catch_unix_error Unix.shutdown this mode` therefore guards only the partial application `Unix.shutdown this`; the call that fails happens outside of it. The same pattern is in thirteen calls, and two calls of `sys.io.Process` are not guarded at all.

## What Changes

- An operating system error in these calls on eval becomes a Haxe exception, as it already is for the rest of the `sys` API:
  - `sys.net.Socket`: creation, `bind`, `listen`, `shutdown`, `setFastSend`, `setBroadcast`, `select`, and reading from and writing to the socket;
  - `Sys.putEnv` with a value, `Sys.systemName`;
  - `sys.io.Process`: `exitCode` and writing to `stdin`.
- Nothing else changes: a call that succeeded gives the same result, and the calls that were guarded keep their messages.
- Regression test in `tests/sys` (`net.TestSocket`), eval only.

## Capabilities

### New Capabilities
- `eval-sys-errors`: what a program on eval sees when the operating system refuses a `sys` call.

### Modified Capabilities

None.

## Impact

- `src/macro/eval/evalStdLib.ml`, `tests/sys/src/net/TestSocket.hx`. Code: the build key moves.
- A program that relied on the compiler exiting on such an error now gets an exception it can catch; uncaught, it still ends the run with an error.
