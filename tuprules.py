#!/usr/bin/env python

import os
import re
import sha
import sys

PKGID_RE = re.compile(r"^#\[pkgid *= *\"(.*?)\"];$")
PKGID_PARSER_RE = re.compile(r"^(?:.*/)?([^#]+)#?(.*)$")

def parse_pkgid(pkgid):
    m = PKGID_PARSER_RE.match(pkgid)
    if m:
        return (m.group(1), m.group(2) or "0.0")
    return None

def discover_outputs(path):
    lib_suffixe = ".so"
    test_suffix = ""
    if sys.platform.startswith("darwin"):
        lib_suffix = ".dylib"
    elif sys.platform.startswith("win"):
        lib_suffix = ".dll"
        test_suffix = ".exe"
        
    for line in open(path).xreadlines():
        m = PKGID_RE.match(line)
        if m:
            pkgid = m.group(1)
            (name, version) = parse_pkgid(pkgid)
            crate_hash = sha.new(pkgid).hexdigest()[:8]
            lib_path = "lib%s-%s-%s%s" % (name, crate_hash, version, lib_suffix)
            test_path = "%s-test%s" % (name, test_suffix)
            return (lib_path, test_path)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)

    lib_path = sys.argv[1]
    other_deps = sys.argv[2:]
    output_path, test_path = discover_outputs(lib_path)

    print ": %s | %s |> $(RUSTC) $(RUSTFLAGS) --lib %%f |> %s" % (
        lib_path, " ".join(other_deps), output_path)
    print ": foreach $(CHECKS-y) | %s |> $(RUSTC) $(RUSTFLAGS) --test -o %%o %%f |> %s" % (
        " ".join(other_deps), test_path)
    print ": foreach $(TESTS-y) |> ./%f |> test_store.png"
