## 1. Process runner

- [x] 1.1 `Process.run` takes an optional environment: the child gets it instead of the one of the calling process, and its program is looked up in the `PATH` of it (not on Windows)

## 2. Requests

- [x] 2.1 `--cmd` and `Sys.command` on eval (`PipeThings.run_command`) start the process in the environment of the request when it has one
- [x] 2.2 `sys.io.Process` on eval does the same

## 3. Verification

- [x] 3.1 `tests/misc/eval/connect_stdin`: `Sys.command`, `sys.io.Process` and `--cmd` show the child the same variables with and without `--connect` — one set for the client only, one changed by `Sys.putEnv`, one set for the server only — and a program found only by the `PATH` of the client; fails on the build before the change, passes after
- [x] 3.2 The rest of `tests/misc/eval/connect_stdin` passes
- [x] 3.3 `tests/server`: the same results as on the build before the change
