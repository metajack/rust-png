tup.include("rust.lua")

STATIC_LIB_EXT = ".a"

CC = "gcc"
CFLAGS = "-Ilibpng"

RUSTC = "rustc"
RUSTFLAGS = "-Llibpng -Llibpng/zlib"

tup.rule("shim.c", CC .. " " .. CFLAGS .. " -o %o -c %f", "%B.o")
tup.rule("shim.o", "ar crs %o %f", "libshim" .. STATIC_LIB_EXT)

rust.library("lib.rs", {"libshim.a", "libpng/libpng.a", "libpng/zlib/libz.a"})
