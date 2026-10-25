interface I {
	var x(get, set):Bool;
}

class A {
	public function new() {}

	public var x(get, set):Bool;

	var _x = false;

	function get_x()
		return _x;

	function set_x(v:Bool) {
		_x = v;
		return v;
	}
}

class B extends A implements I {}

class Main {
	static function main() {
		var i:I = new B();
		i.x = true;
		if (!i.x)
			throw "i.x should be true";
	}
}
