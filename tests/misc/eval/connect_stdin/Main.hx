import sys.io.Process;

using StringTools;

class Main {
	static function main() {
		var port = 7300;

		// Start the compilation server, with a variable and a program in its PATH its clients do not have
		var path = Sys.getEnv("PATH");
		Sys.putEnv("HAXE_CONNECT_SERVER", "server");
		if (Sys.systemName() != "Windows")
			Sys.putEnv("PATH", path + ":" + sys.FileSystem.absolutePath("tools/server"));
		var server = new Process("haxe", ["--wait", Std.string(port)]);
		Sys.sleep(1.0);
		Sys.putEnv("HAXE_CONNECT_SERVER", null);
		Sys.putEnv("PATH", path);

		var failures = 0;
		var count = 0;

		function test(name:String, f:() -> Bool) {
			count++;
			Sys.print('  Test: $name ... ');
			if (f()) {
				Sys.println("OK");
			} else {
				Sys.println("FAILED");
				failures++;
			}
		}

		// Test 1: Piped stdin through --connect
		test("stdin line forwarding", () -> {
			var client = new Process("haxe", ["--connect", Std.string(port), "-cp", ".", "--main", "StdinEcho", "--interp"]);
			client.stdin.writeString("hello world\n");
			client.stdin.close();
			var stdout = client.stdout.readAll().toString().trim();
			var exitCode = client.exitCode();
			client.close();
			if (stdout != "Got: hello world") {
				Sys.println('\n    Expected: "Got: hello world"');
				Sys.println('    Got: "$stdout"');
				return false;
			}
			return exitCode == 0;
		});

		// Test 2: Multiple lines through --connect
		test("stdin multiline forwarding", () -> {
			var client = new Process("haxe", [
				"--connect", Std.string(port), "-cp", ".", "--main", "StdinMultiline", "--interp"
			]);
			client.stdin.writeString("line1\nline2\nline3\n");
			client.stdin.close();
			var stdout = client.stdout.readAll().toString().trim();
			var exitCode = client.exitCode();
			client.close();
			if (stdout != "Got 3 lines: line1, line2, line3") {
				Sys.println('\n    Expected: "Got 3 lines: line1, line2, line3"');
				Sys.println('    Got: "$stdout"');
				return false;
			}
			return exitCode == 0;
		});

		// Test 3: Sys.getChar over --connect
		test("stdin getChar forwarding", () -> {
			var client = new Process("haxe", ["--connect", Std.string(port), "--run", "StdinChar"]);
			client.stdin.writeString("h");
			client.stdin.close();
			var stdout = client.stdout.readAll().toString().trim();
			var exitCode = client.exitCode();
			client.close();
			if (stdout != "Got: h") {
				Sys.println('\n    Expected: "Got: h"');
				Sys.println('    Got: "$stdout"');
				return false;
			}
			return exitCode == 0;
		});

		// Test 4: Sys.getChar through --cmd
		test("stdin getChar forwarding to command", () -> {
			var client = new Process("haxe", ["--connect", Std.string(port), "--cmd", "haxe --run StdinChar"]);
			client.stdin.writeString("h");
			client.stdin.close();
			var stdout = client.stdout.readAll().toString().trim();
			var exitCode = client.exitCode();
			client.close();
			if (stdout != "Got: h") {
				Sys.println('\n    Expected: "Got: h"');
				Sys.println('    Got: "$stdout"');
				return false;
			}
			return exitCode == 0;
		});

		// Test 5: Sys.getChar with newline char — verifies \n doesn't get
		// special-cased in the stdin forwarding protocol
		test("stdin getChar newline forwarding", () -> {
			var client = new Process("haxe", ["--connect", Std.string(port), "--run", "StdinChar"]);
			client.stdin.writeString("\n");
			client.stdin.close();
			var stdout = client.stdout.readAll().toString().trim();
			var exitCode = client.exitCode();
			client.close();
			if (stdout != "Got: \\n") {
				Sys.println('\n    Expected: "Got: \\n"');
				Sys.println('    Got: "$stdout"');
				return false;
			}
			return exitCode == 0;
		});

		// Test 6: Piped stdin through --cmd
		test("stdin line forwarding to command", () -> {
			var client = new Process("haxe", ["--connect", Std.string(port), "--cmd", "cat -"]);
			client.stdin.writeString("hello world\n");
			client.stdin.close();
			var stdout = client.stdout.readAll().toString().trim();
			var exitCode = client.exitCode();
			client.close();
			if (stdout != "hello world") {
				Sys.println('\n    Expected: "hello world"');
				Sys.println('    Got: "$stdout"');
				return false;
			}
			return exitCode == 0;
		});

		// Test 7: No stdin consumed (just compile) - should not hang
		test("no-stdin request completes", () -> {
			var client = new Process("haxe", ["--connect", Std.string(port), "-cp", ".", "--main", "StdinEcho", "--no-output"]);
			client.stdin.close();
			var exitCode = client.exitCode();
			client.close();
			return exitCode == 0;
		});

		// Test 8: Sys.getChar via --cmd without explicitly closing stdin
		// (closer to real-world use where stdin isn't EOF-terminated)
		test("stdin getChar via --cmd without close", () -> {
			var client = new Process("haxe", ["--connect", Std.string(port), "--cmd", "haxe --run StdinChar"]);
			client.stdin.writeString("h");
			var stdout = client.stdout.readAll().toString().trim();
			var exitCode = client.exitCode();
			client.close();
			if (stdout != "Got: h") {
				Sys.println('\n    Expected: "Got: h"');
				Sys.println('    Got: "$stdout"');
				return false;
			}
			return exitCode == 0;
		});

		// Test 9: Sys.getChar via --run without explicitly closing stdin
		test("stdin getChar via --run without close", () -> {
			var client = new Process("haxe", ["--connect", Std.string(port), "--run", "StdinChar"]);
			client.stdin.writeString("h");
			var stdout = client.stdout.readAll().toString().trim();
			var exitCode = client.exitCode();
			client.close();
			if (stdout != "Got: h") {
				Sys.println('\n    Expected: "Got: h"');
				Sys.println('    Got: "$stdout"');
				return false;
			}
			return exitCode == 0;
		});

		// Test 10: Output is streamed immediately, not buffered until program exit.
		// StreamOutput traces "before_stdin", then blocks on stdin.
		// If --connect streaming works, we can read that line before sending stdin.
		// If output were buffered until exit this test would deadlock because the
		// program waits for stdin which we only send after reading the first line.
		test("streaming output not buffered until exit", () -> {
			var client = new Process("haxe", [
				"--connect", Std.string(port), "-cp", ".", "--main", "StreamOutput", "--interp"
			]);
			// This readLine() returns immediately if streaming works,
			// because the trace happens before the program reads stdin.
			var firstLine = client.stdout.readLine();
			// Unblock the program by sending a stdin byte.
			client.stdin.writeByte(0);
			client.stdin.close();
			var rest = client.stdout.readAll().toString().trim();
			var exitCode = client.exitCode();
			client.close();
			if (!firstLine.contains("before_stdin")) {
				Sys.println('\n    First line should contain "before_stdin", got: "$firstLine"');
				return false;
			}
			if (!rest.contains("after_stdin")) {
				Sys.println('\n    Remaining output should contain "after_stdin", got: "$rest"');
				return false;
			}
			return exitCode == 0;
		});

		// Test 11: With --prompt (used when double-clicking a .hxml), errors must be
		// printed before "Press enter to exit...", not buffered until process exit.
		// stderr is merged into stdout so the output order can be checked.
		test("prompt shows errors before waiting", () -> {
			var client = new Process("haxe --prompt -cp . --main PromptError --no-output 2>&1");
			client.stdin.writeString("\n");
			client.stdin.close();
			var stdout = client.stdout.readAll().toString();
			client.close();
			var errorPos = stdout.indexOf("PromptError");
			var promptPos = stdout.indexOf("Press enter to exit");
			if (errorPos == -1 || promptPos == -1 || errorPos > promptPos) {
				Sys.println('\n    Expected error before prompt, got: "$stdout"');
				return false;
			}
			return true;
		});

		// Test 12: a program under --run gets what it gets without --connect: the
		// arguments after the class as they were typed, the environment of the
		// client rather than the one the server was started in, and its exit code.
		test("--run arguments, environment and exit code", () -> {
			Sys.putEnv("HAXE_CONNECT_PROBE", "client");
			var args = ["-cp", ".", "--run", "RunProbe", "a b", "-x y", "", "#c", "--connect", "1"];
			function run(pre:Array<String>) {
				var p = new Process("haxe", pre.concat(args));
				p.stdin.close();
				var out = p.stdout.readAll().toString();
				var err = p.stderr.readAll().toString().trim();
				var code = p.exitCode();
				p.close();
				return 'exit $code\n$out$err';
			}
			var cold = run([]);
			var connected = run(["--connect", Std.string(port)]);
			var expected = 'exit 3\nargs=["a b","-x y","","#c","--connect","1"]\ngetEnv=client\nenvironment=client\nputEnv=changed,changed\nerr\x025\ntail';
			if (cold != expected || connected != expected) {
				Sys.println('\n    Expected: "$expected"');
				Sys.println('    Without --connect: "$cold"');
				Sys.println('    With --connect: "$connected"');
				return false;
			}
			return true;
		});

		// Test 13: a process the request starts (Sys.command, sys.io.Process, --cmd) gets
		// what it gets without --connect: the environment of the client with what
		// Sys.putEnv changed, nothing of the server, and a program found by the PATH of the client.
		test("environment of child processes", () -> {
			var windows = Sys.systemName() == "Windows";
			Sys.putEnv("HAXE_CONNECT_PROBE", "client");
			if (!windows)
				Sys.putEnv("PATH", sys.FileSystem.absolutePath("tools") + ":" + Sys.getEnv("PATH"));
			var args = ["-cp", ".", "--main", "ChildProbe", "--interp", "--cmd", "haxe -cp . --run ChildEnv cmd"];
			function run(pre:Array<String>) {
				var p = new Process("haxe", pre.concat(args));
				p.stdin.close();
				var out = p.stdout.readAll().toString();
				var err = p.stderr.readAll().toString().trim();
				var code = p.exitCode();
				p.close();
				return 'exit $code\n$out$err'.replace("\r\n", "\n");
			}
			var cold = run([]);
			var connected = run(["--connect", Std.string(port)]);
			var expected = "exit 0\ncommand client put null\nprocess client put null\n" + (windows ? "" : "tool client put \n") + "cmd client put null\n";
			if (cold != expected || connected != expected) {
				Sys.println('\n    Expected: "$expected"');
				Sys.println('    Without --connect: "$cold"');
				Sys.println('    With --connect: "$connected"');
				return false;
			}
			return true;
		});

		// Clean up the server
		server.kill();
		server.close();

		Sys.println('Done running $count tests with $failures failures');
		Sys.exit(failures);
	}
}
