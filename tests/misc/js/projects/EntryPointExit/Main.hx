class Main {
	static function main() {
		// fail instead of hanging if the main loop keeps the process alive
		(untyped setTimeout)(() -> {
			trace("main loop did not exit");
			js.Syntax.code("process.exit(1)");
		}, 5000).unref();

		var stopped = haxe.MainLoop.add(() -> {});
		stopped.stop();

		var count = 0;
		var event:haxe.MainLoop.MainEvent = null;
		event = haxe.MainLoop.add(() -> {
			js.Syntax.code("console.log({0})", count++);
			if (count == 3)
				event.stop();
		});
	}
}
