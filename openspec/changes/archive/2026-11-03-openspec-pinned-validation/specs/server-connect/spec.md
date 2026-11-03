## MODIFIED Requirements

### Requirement: Eval code of the request sees the environment of the client
For a request made by `haxe --connect`, `Sys.getEnv` and `Sys.environment` on eval — in the program under `--run` and in the macros of the request — SHALL answer from the environment of the client process, not from the server's. `Sys.putEnv` SHALL change what they answer for the rest of the request only, never the environment of the server.

#### Scenario: Variable set only for the client
- **WHEN** the server was started without `X` and `X=client haxe --connect <port> --run Main` is run
- **THEN** `Sys.getEnv("X")` and `Sys.environment()["X"]` in `Main` are `client`

#### Scenario: Variable set only for the server
- **WHEN** the server was started with `X=server` and the client is run without `X`
- **THEN** `Sys.getEnv("X")` in `Main` is `null`

#### Scenario: putEnv
- **WHEN** the program calls `Sys.putEnv("X", "changed")`
- **THEN** `Sys.getEnv("X")` and `Sys.environment()["X"]` are `changed` until the request ends
- **AND** the next request does not see `X=changed`, whoever sends it

#### Scenario: Request that carries no environment
- **WHEN** a request not made by `haxe --connect` runs eval code
- **THEN** `Sys.getEnv` and `Sys.environment` answer from the environment of the server

### Requirement: A process started by the request gets the environment of the client
A process started by a request made by `haxe --connect` (by `Sys.command` or `sys.io.Process` on eval, or by `--cmd`) SHALL get the environment eval code of the request sees at that moment — the client's, with the request's `Sys.putEnv` changes so far, nothing of the server's — and SHALL find its program by the `PATH` of that environment, or by the default search path of the system when it has none, never by the `PATH` of the server.

#### Scenario: Variable set only for the client
- **WHEN** the server was started without `X` and a program run with `X=client haxe --connect <port> --run Main` calls `Sys.command("sh", ["-c", "echo $X"])`
- **THEN** the child prints `client`
- **AND** so does a child started with `new sys.io.Process("sh", ["-c", "echo $X"])` and one started by `--cmd 'echo $X'`

#### Scenario: Variable set only for the server
- **WHEN** the server was started with `X=server` and the client is run without `X`
- **THEN** `X` is not set in a child the request starts

#### Scenario: putEnv before the child is started
- **WHEN** the program calls `Sys.putEnv("X", "changed")` and then starts a child
- **THEN** `X` is `changed` in the child
- **AND** a child started by the next request does not see `X=changed`

#### Scenario: Request that carries no environment
- **WHEN** a request not made by `haxe --connect` starts a process
- **THEN** the process gets the environment of the server

#### Scenario: haxelib called by the compiler
- **WHEN** the compiler itself calls `haxelib` for the request (to resolve `-lib`, to build for C++ or HashLink)
- **THEN** this requirement does not cover it: `haxelib` runs in the environment of the server

#### Scenario: Program found by the PATH of the client
- **WHEN** the client is run with a directory first in its `PATH` that holds a program `tool`, the server was started without that directory, and the request calls `new sys.io.Process("tool", [])`
- **THEN** the `tool` of that directory is run

#### Scenario: Program in the PATH of the server only
- **WHEN** the server was started with a directory in its `PATH` that holds a program `tool`, the client is run without that directory, and the request calls `new sys.io.Process("tool", [])`
- **THEN** the program is not found, as without `--connect`
- **AND** it is not found either after the request calls `Sys.putEnv("PATH", null)`

#### Scenario: Argument list on Windows
- **WHEN** on Windows the request starts a program with an argument list rather than a command line
- **THEN** the program is looked up in the `PATH` of the server; a command line, which the shell runs, is looked up as this requirement states
