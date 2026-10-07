package cases.display.issues;

class ReferencesCandidates extends DisplayTestCase {
	/**
		class Main {
			static function main() {
				{-1-}uniqueName{-2-}();
			}

			static public function uniq{-3-}ueName() return 1;
		}
	**/
	function testAliasedImport(_) {
		// The import is the only place where the file mentions the name.
		vfs.putContent("Alias.hx", "import Main.uniqueName as renamed;

class Alias {
	static function use() return renamed();
}");
		// The server reads the class paths once per context: the define gives this test its own.
		var result = runHaxeJson(["-cp", ".", "-D", "references-aliased-import"], DisplayMethods.FindReferences, {
			file: file,
			kind: WithBaseAndDescendants,
			offset: offset(3)
		});
		Assert.same([range(1, 2)], [for (l in result) if (l.file.toString().endsWith("Main.hx")) l.range]);
		Assert.equals(1, result.filter(l -> l.file.toString().endsWith("Alias.hx")).length);
	}

	/**
		class Main {
			static function main() {
				{-1-}uniqueName{-2-}();
			}

			static public function uniq{-3-}ueName() return 1;
		}
	**/
	function testMacroErrorInOtherCandidate(_) {
		vfs.putContent("BuildMacro.hx", "class BuildMacro {
	macro static public function build():Array<haxe.macro.Expr.Field> {
		return haxe.macro.Context.getBuildFields();
	}
}");
		vfs.putContent("PoisonMacro.hx", "class PoisonMacro {
	macro static public function call() {
		return missing.Missing.value();
	}
}");
		// Whichever of the two is typed first fails in the macro context after its own class is built;
		// the build macro of the other one has to run all the same.
		for (name in ["CandA", "CandB"]) {
			vfs.putContent('$name.hx', '@:build(BuildMacro.build())
class $name {
	static function use() return Main.uniqueName();
}

class ${name}Poison {
	static function poison() return PoisonMacro.call();
}');
		}
		var result = runHaxeJson(["-cp", ".", "-D", "references-macro-error"], DisplayMethods.FindReferences, {
			file: file,
			kind: WithBaseAndDescendants,
			offset: offset(3)
		});
		Assert.same([range(1, 2)], [for (l in result) if (l.file.toString().endsWith("Main.hx")) l.range]);
		Assert.equals(1, result.filter(l -> l.file.toString().endsWith("CandA.hx")).length);
		Assert.equals(1, result.filter(l -> l.file.toString().endsWith("CandB.hx")).length);
	}
}
