class RunProbe {
	static function main() {
		Sys.println("args=" + haxe.Json.stringify(Sys.args()));
		Sys.println("getEnv=" + Sys.getEnv("HAXE_CONNECT_PROBE"));
		Sys.println("environment=" + Sys.environment()["HAXE_CONNECT_PROBE"]);
		Sys.putEnv("HAXE_CONNECT_PROBE", "changed");
		Sys.println("putEnv=" + Sys.getEnv("HAXE_CONNECT_PROBE") + "," + Sys.environment()["HAXE_CONNECT_PROBE"]);
		// neither a marker of the server protocol in the output nor a line without its newline changes the code
		Sys.stderr().writeString("err\x025\ntail");
		Sys.exit(3);
	}
}
