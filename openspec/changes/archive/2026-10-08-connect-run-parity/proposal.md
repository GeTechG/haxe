## Why

A program started with `haxe --connect <port> … --run Main a b` does not run as the same command does without `--connect`: it gets no arguments, reads the environment the server was started in and always ends with code 0 or 1. A tool that is run from its sources on eval can therefore not use the compilation server to skip retyping itself on every call (0.78 s cold against 0.09–0.19 s warm for the tool that asked, HX-11).

- The client rebuilds its command line for the server and leaves the arguments after `--run <class>` out.
- The server process has its own environment and the request carries none.
- The answer of the server can only say "failed", which the client turns into 1.

## What Changes

- The client sends, after its arguments, the arguments of the program under `--run` and its own environment. They are escaped one value per line: the argument lines are read like an hxml file, which would split `-x y`, strip spaces and quotes, and drop empty values and those starting with `#`.
- For a request that carries an environment, `Sys.getEnv`, `Sys.environment` and `Sys.putEnv` on eval work on that environment and leave the one of the server alone — for the program under `--run` and for the macros of the same request, as without `--connect`. A request without one (an editor, an older client) sees the environment of the server, as before.
- The server sends the exit code when it is not 0 or 1, as a number after the error marker, on a line of its own after everything the request wrote; the client exits with it. An older client reads the same line as "failed".
- Not changed: a process the program starts (`Sys.command`, `sys.io.Process`) and `--cmd` still inherit the environment of the server. That needs the process runner outside this change: HX-12.
- Test in `tests/misc/eval/connect_stdin`, the suite that already runs a real server and client.

## Capabilities

### New Capabilities
- `server-connect`: what a request made through `--connect` gets from its client compared with the same command run without a server.

### Modified Capabilities

None.

## Impact

- `src/compiler/server/server.ml` (client and server side of the protocol), `src/macro/eval/evalStdLib.ml` (`Sys` environment functions), `tests/misc/eval/connect_stdin/`. Code: the build key moves.
- Wire format: a new client adds a `\002` section to the request, which an older server does not understand — client and server are the same binary in every supported setup. Requests without the section are handled as before.
- Without `--connect` nothing changes.
