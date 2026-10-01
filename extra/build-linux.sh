#!/usr/bin/env bash
# Builds the Linux compiler and packs it with std into out/haxe-linux64.tar.gz.
# Requires opam and the libpcre2, zlib and mbedtls development packages.
set -euo pipefail
cd "$(dirname "$0")/.."

OCAML_VERSION=${OCAML_VERSION:-5.3.0}
export OPAMYES=1

command -v opam >/dev/null || {
	echo "opam not found: install opam, libpcre2-dev, zlib1g-dev and libmbedtls-dev" >&2
	exit 1
}
[ -d "${OPAMROOT:-$HOME/.opam}" ] || opam init --bare --no-setup
[ -d _opam ] || opam switch create . "$OCAML_VERSION" --no-install

# conf-neko is only needed to build haxelib, which is not part of this package
deps=$(mktemp -d)
trap 'rm -rf "$deps"' EXIT
grep -v conf-neko haxe.opam > "$deps/haxe-deps.opam"
opam install "$deps/haxe-deps.opam" --deps-only --assume-depexts

# the pcre2 opam package links libpcre2-8 on its own, outside the Makefile's static block:
# put a directory holding only the static archive first on the linker search path
ln -s "$(gcc -print-file-name=libpcre2-8.a)" "$deps/"
OCAMLPARAM="ccopt=-L$deps,_" opam exec -- make -s -j"$(nproc)" STATICLINK=1 ADD_REVISION=1 haxe
./haxe -version

mkdir -p out
tar -czf out/haxe-linux64.tar.gz haxe std
