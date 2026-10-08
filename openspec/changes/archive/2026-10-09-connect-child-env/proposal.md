## Why

A process started by a request of `haxe --connect` runs in the environment the server was started in, while the eval code that starts it already reads the environment of the client (HX-11). The same program therefore behaves differently with and without a compilation server (HX-12):

- `Sys.putEnv("REQUEST", file); Sys.command("haxe", …)` hands a value to the child through the environment; under the server the child does not see it.
- A script that puts a shim first in the `PATH` of the call gets the program the `PATH` of the server names.

## What Changes

- A process started by a request that carries the environment of its client — `Sys.command` and `sys.io.Process` on eval, `--cmd` — gets that environment, with what `Sys.putEnv` changed in the request so far, instead of the one of the server.
- Its program is looked up in the `PATH` of that environment. `Unix.create_process_env` looks it up in the `PATH` of the calling process, so the runner does the lookup itself. Not on Windows, where a program started with an argument list (`new sys.io.Process(cmd, args)`) is still found by the `PATH` of the server; a command line (`Sys.command`, `--cmd`, `new sys.io.Process(cmd)`) goes through the shell, which uses the environment it is given, on every system.
- A request without an environment (an editor, an older client) starts processes in the environment of the server, as before.
- Not changed: the `haxelib` the compiler itself calls (`-lib`, the C++ and HashLink builds) still runs in the environment of the server. The server keeps the answer of `haxelib path` between requests, so answering it per client is a decision of its own: HX-13.
- Test in `tests/misc/eval/connect_stdin`, next to the one of HX-11.

## Capabilities

### New Capabilities

None.

### Modified Capabilities
- `server-connect`: the environment of the client reaches the processes the request starts, which the capability excluded so far.

## Impact

- `libs/extc/process.ml` (`Process.run` takes an environment), `src/compiler/pipeThings.ml` and `src/compiler/compiler.ml` (`--cmd`, `Sys.command`), `src/macro/eval/evalStdLib.ml` (`sys.io.Process`), `tests/misc/eval/connect_stdin/`. Code: the build key moves.
- Without `--connect`, and for a request without the client section, nothing changes.
