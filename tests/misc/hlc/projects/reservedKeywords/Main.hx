@:build(Macro.build())
class Main {
	// Macros of <limits.h>
	static var USHRT_MAX = 1;
	static var INT_MAX = 2;

	public static function main() {
		USHRT_MAX += 10;
		INT_MAX += 10;
		var l = new Limits();
		l.USHRT_MAX += 10;
		l.INT_MAX += 10;
		untyped $prefetch(l.isfinite, 0);
		if (USHRT_MAX != 11 || INT_MAX != 12 || l.USHRT_MAX != 13 || l.INT_MAX != 14)
			throw "wrong field values";
	}
}

class Limits {
	public var USHRT_MAX = 3;
	public var INT_MAX = 4;
	// A function-like macro of <math.h>
	public var isfinite = 5;

	public function new() {}
}
