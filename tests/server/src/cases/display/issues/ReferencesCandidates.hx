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

	/**
		class Main {
			static function main() {
				{-1-}uniqueName{-2-}();
			}

			static public function uniq{-3-}ueName() return 1;
		}
	**/
	function testMacroModuleErrorInOtherCandidate(_) {
		// The module of the macro does not load: the class it imports fails, which leaves its own methods to
		// be typed in the macro context.
		vfs.putContent("PoisonMacro.hx", "import PoisonDep;

class PoisonMacro {
	macro static public function build():Array<haxe.macro.Expr.Field> {
		return missing.Missing.value();
	}
}");
		vfs.putContent("PoisonDep.hx", "class PoisonDep extends missing.Missing {}");
		// The build macros of both candidates are loaded after that, and have to run all the same.
		for (name in ["CandA", "CandB"]) {
			vfs.putContent('Build$name.hx', 'class Build$name {
	macro static public function build():Array<haxe.macro.Expr.Field> {
		return haxe.macro.Context.getBuildFields();
	}
}');
			vfs.putContent('$name.hx', '@:build(Build$name.build())
class $name {
	static function use() return Main.uniqueName();
}

@:build(PoisonMacro.build())
class ${name}Poison {}');
		}
		var result = runHaxeJson(["-cp", ".", "-D", "references-macro-module-error"], DisplayMethods.FindReferences, {
			file: file,
			kind: WithBaseAndDescendants,
			offset: offset(3)
		});
		Assert.same([range(1, 2)], [for (l in result) if (l.file.toString().endsWith("Main.hx")) l.range]);
		Assert.equals(1, result.filter(l -> l.file.toString().endsWith("CandA.hx")).length);
		Assert.equals(1, result.filter(l -> l.file.toString().endsWith("CandB.hx")).length);
	}

	/**
		class Main {
			static function main() {
				new {-1-}Target{-2-}();
			}
		}

		class Tar{-3-}get {
			public function new() {}
		}

		@:build(BuildMacro.build())
		class Built {}
	**/
	function testTypeHintWithoutPosition(_) {
		// A type path which a macro builds by hand has no position.
		vfs.putContent("BuildMacro.hx", "import haxe.macro.Expr;

class BuildMacro {
	macro static public function build():Array<Field> {
		var fields = haxe.macro.Context.getBuildFields();
		fields.push({
			name: 'target',
			kind: FVar(TPath({pack: [], name: 'Main', sub: 'Target'})),
			pos: haxe.macro.Context.currentPos()
		});
		return fields;
	}
}");
		var result = runHaxeJson(["-cp", ".", "-D", "references-no-position"], DisplayMethods.FindReferences, {
			file: file,
			kind: WithBaseAndDescendants,
			offset: offset(3)
		});
		Assert.isFalse(result.contains(null));
		Assert.same([range(1, 2)], [for (l in result) if (l != null) l.range]);
	}
}
