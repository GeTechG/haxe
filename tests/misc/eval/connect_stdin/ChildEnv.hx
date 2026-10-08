class ChildEnv {
	static function main() {
		Sys.println(Sys.args()[0] + " " + Sys.getEnv("HAXE_CONNECT_PROBE") + " " + Sys.getEnv("HAXE_CONNECT_PUT") + " " + Sys.getEnv("HAXE_CONNECT_SERVER"));
	}
}
