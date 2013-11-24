tup.rule("shim.c", "^ CC %f^ $(CC) $(CFLAGS) -o %o -c %f", "%B.o")
tup.rule("shim.o", "^ AR %f^ $(AR) crs %o %f", "libshim.a")

rust.library("lib.rs", {"libshim.a", "libpng/libpng.a", "libpng/zlib/libz.a"})
