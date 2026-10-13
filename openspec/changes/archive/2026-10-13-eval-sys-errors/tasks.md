## 1. Interpreter

- [x] 1.1 Every `catch_unix_error` call in `evalStdLib.ml` guards the whole call, not a partial application: sockets, `Sys.putEnv`, `Sys.systemName`
- [x] 1.2 `NativeProcess.exitCode` and `writeStdin` go through `process_catch`

## 2. Verification

- [x] 2.1 `tests/sys` `net.TestSocket.testShutdownNotConnected`: ends the run with `Unix.Unix_error` on the build before the change, passes after
- [x] 2.2 The rest of `tests/sys` on eval: the same results as on the build before the change
