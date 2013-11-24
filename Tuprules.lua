tup.include("rust.lua")

if CC == nil then
  CC = "gcc"
end
if AR == nil then
  AR = "ar"
end
if RUSTC == nil then
  RUSTC = "rustc"
end

CFLAGS = "-Ilibpng"
RUSTFLAGS = "-Llibpng -Llibpng/zlib"

