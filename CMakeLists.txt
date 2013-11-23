cmake_minimum_required(VERSION 2.8)

project(rust-png)

include(rust.cmake)

add_library(shim STATIC shim.c)

file(GLOB CRATE_SRC RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.rs)
list(REMOVE_ITEM CRATE_SRC lib.rs)
list(INSERT CRATE_SRC 0 lib.rs)

add_rust_library(${CRATE_SRC} shim)
