cmake_minimum_required(VERSION 2.8)

set(RUSTC rustc)
set(RUSTFLAGS)

add_custom_target(check)

function(add_rust_library libfile)
  file(STRINGS ${libfile} pkgid
       LIMIT_COUNT 1
       REGEX "^#[[]pkgid *= *\".*\"];$")
  string(REGEX REPLACE "^#.*\"(.*)\"];" "\\1" pkgid ${pkgid})
  string(SHA1 crate_hash ${pkgid})
  string(SUBSTRING ${crate_hash} 0 8 crate_hash)
  string(REGEX REPLACE ".*/([^#]+).*" "\\1" crate_name ${pkgid})
  string(REGEX REPLACE ".*#" "" crate_version ${pkgid})
  if(NOT crate_version)
    set(crate_version "0.0")
  endif()
  set(lib_output "lib${crate_name}-${crate_hash}-${crate_version}${CMAKE_SHARED_LIBRARY_SUFFIX}")
  set(test_output "${crate_name}-test${CMAKE_EXECUTABLE_SUFFIX}")

  configure_file(${libfile} ${CMAKE_BINARY_DIR}/.${libfile}.cmake-trigger)

  add_custom_command(
    OUTPUT ${lib_output}
    COMMAND ${RUSTC}
    ARGS ${RUSTFLAGS} --lib ${libfile}
    DEPENDS ${ARGV})

  add_custom_command(
    OUTPUT ${test_output}
    COMMAND ${RUSTC}
    ARGS ${RUSTFLAGS} --test ${libfile} -o ${test_output}
    DEPENDS ${ARGV})

  add_custom_target(${crate_name} ALL DEPENDS ${lib_output})
  add_custom_target(
    check-${crate_name}
    COMMAND ./${test_output}
    DEPENDS ${test_output})

  add_dependencies(check check-${crate_name})
endfunction(add_rust_library)
