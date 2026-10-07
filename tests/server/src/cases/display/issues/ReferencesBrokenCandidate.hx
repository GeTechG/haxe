package cases.display.issues;

class ReferencesBrokenCandidate extends DisplayTestCase {
	/**
		class Main {
			static function main() {
				{-1-}uniqueName{-2-}();
			}

			static public function uniq{-3-}ueName() return 1;
		}
	**/
	function test(_) {
		// Only loaded because it mentions the name: the first class fails the module, the other
		// two are still queued when the usages are collected.
		vfs.putContent("Broken.hx", "class Broken1 implements missing.Missing.Sub {}
class Broken2 implements missing.Missing.Sub {}
class Broken3 implements missing.Missing.Sub {}

class Broken {
	static function a() return Main.uniqueName();
	static function b() return Main.uniqueName();
}");
		var result = runHaxeJson(["-cp", "."], DisplayMethods.FindReferences, {
			file: file,
			kind: WithBaseAndDescendants,
			offset: offset(3)
		});
		Assert.same([range(1, 2)], [for (l in result) if (l.file.toString().endsWith("Main.hx")) l.range]);
		Assert.equals(2, result.filter(l -> l.file.toString().endsWith("Broken.hx")).length);
	}
}
