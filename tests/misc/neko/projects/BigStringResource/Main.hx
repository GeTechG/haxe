import haxe.io.Bytes;

class Main {
	// over 300 chunks of 65535 bytes, the last one partial
	static inline var LENGTH = 20 * 1024 * 1024 + 7;

	static function data():Bytes {
		var b = Bytes.alloc(LENGTH);
		// every byte value, in a pattern that does not repeat every chunk; no overflow on any target
		for (i in 0...LENGTH)
			b.set(i, (i ^ (i >> 8) ^ (i >> 16)) & 0xFF);
		return b;
	}

	#if macro
	static function addResource() {
		haxe.macro.Context.addResource("big", data());
	}
	#else
	static function main() {
		var s = haxe.Resource.getString("big");
		if (s == null) {
			Sys.println("Resource not found");
			Sys.exit(1);
		}
		if (Bytes.ofString(s).compare(data()) != 0) {
			Sys.println('Resource differs: ${s.length} bytes, expected $LENGTH');
			Sys.exit(1);
		}
	}
	#end
}
