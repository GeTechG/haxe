import sys.io.Process;

class ChildProbe {
	static function main() {
		Sys.putEnv("HAXE_CONNECT_PUT", "put");
		var child = ["-cp", ".", "--run", "ChildEnv"];
		Sys.command("haxe", child.concat(["command"]));
		function run(cmd:String, args:Array<String>) {
			var p = new Process(cmd, args);
			Sys.print(p.stdout.readAll().toString());
			p.close();
		}
		run("haxe", child.concat(["process"]));
		// found by the PATH of the client only; Windows looks a program with arguments up in the PATH of the server
		if (Sys.systemName() != "Windows") {
			run("connect-probe-tool", []);
			// in the PATH of the server only: not found, with a PATH and without one
			run("connect-server-tool", []);
			var path = Sys.getEnv("PATH");
			Sys.putEnv("PATH", null);
			run("connect-server-tool", []);
			Sys.putEnv("PATH", path);
		}
	}
}
