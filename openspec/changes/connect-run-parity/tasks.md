## 1. Protocol

- [x] 1.1 Client (`Server.Connect.do_connect`): send the arguments after `--run <class>` and the environment after the argument lines, escaped one per line
- [x] 1.2 Server (`Server.wait_loop`): read that section, give the arguments to the `--run` of the request, keep the environment with the request
- [x] 1.3 Server sends an exit code other than 0 and 1 after the error marker; the client exits with it, also when the program left its last line of stderr without a newline

## 2. Environment

- [x] 2.1 `Sys.getEnv`, `Sys.environment`, `Sys.putEnv` on eval work on the environment of the request when it has one

## 3. Verification

- [x] 3.1 `tests/misc/eval/connect_stdin`: the same `--run` command with and without `--connect` prints the same arguments and environment and ends with the same code; fails on the build before the change, passes after
- [x] 3.2 The rest of `tests/misc/eval/connect_stdin` passes
- [x] 3.3 `tests/server`: the same results as on the build before the change (requests that carry no client section are handled as before)
- [x] 3.4 By hand, with and without `--connect`: exit codes 0, 1, 3, 255, -1; an uncaught exception; a compilation error; `--run` inside an hxml file; a variable unset in the client and set in the server
