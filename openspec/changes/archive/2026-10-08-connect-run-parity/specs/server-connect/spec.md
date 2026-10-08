## ADDED Requirements

### Requirement: A program under --run gets its arguments
A command with `--connect` SHALL give the program it runs with `--run <class>` the arguments that follow the class, the same list `Sys.args()` returns for the command without `--connect`: every argument as it was typed, including one with spaces, one that starts with `-` or `#`, and an empty one, and including whatever looks like a compiler argument.

#### Scenario: Arguments an hxml line would change
- **WHEN** `haxe --connect <port> -cp . --run Main "a b" "-x y" "" "#c" --connect 1` is run
- **THEN** `Sys.args()` in `Main` is `["a b", "-x y", "", "#c", "--connect", "1"]`

### Requirement: Eval code of the request sees the environment of the client
For a request made by `haxe --connect`, `Sys.getEnv` and `Sys.environment` on eval — in the program under `--run` and in the macros of the request — SHALL answer from the environment of the client process, not from the one the server was started in. `Sys.putEnv` SHALL change what they answer for the rest of the request and SHALL NOT change the environment of the server, so that nothing of it reaches a later request. A request that carries no environment (one not made by `haxe --connect`) SHALL see the environment of the server.

A process started by the request (`Sys.command`, `sys.io.Process`, `--cmd`) is not covered: it inherits the environment of the server.

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

### Requirement: The client exits with the code of the request
A command with `--connect` SHALL exit with the code the same command exits with when run without `--connect`: the code a program under `--run` passes to `Sys.exit`, 1 for a failed compilation or an uncaught exception, 0 otherwise. What the program wrote to the standard error before it exited SHALL NOT change the code.

#### Scenario: Sys.exit with a code other than 0 and 1
- **WHEN** the program under `--run` calls `Sys.exit(3)`
- **THEN** `haxe --connect <port> --run Main` exits with 3

#### Scenario: Unterminated line on the standard error
- **WHEN** the program writes `oops` without a newline to the standard error and calls `Sys.exit(4)`
- **THEN** the client prints `oops` on its standard error and exits with 4

#### Scenario: Output that looks like the answer of the server
- **WHEN** the program writes the byte `\x02` followed by `5` inside a line of its standard error and calls `Sys.exit(3)`
- **THEN** the client exits with 3

#### Scenario: Failed compilation
- **WHEN** the request fails to compile
- **THEN** the client exits with 1

### Requirement: Nothing changes without --connect
A command without `--connect`, and a request that reaches the server without the client section, SHALL behave as before this capability: arguments, environment and exit code come from the process that runs the compiler.

#### Scenario: Request of an editor
- **WHEN** a request is sent to the server by a client that speaks the protocol without the client section
- **THEN** it is processed with the environment of the server and answered in the same format as before
