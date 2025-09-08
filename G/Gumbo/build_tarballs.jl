# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder
using Pkg

name = "Gumbo"
version = v"0.13.2"

# Build from the tag in the active upstream
sources = [
    GitSource("https://codeberg.org/gumbo-parser/gumbo-parser.git",
              "322c54c178590ba42b8b04e8c0e4840595a1f717"),

]

# Bash recipe for building across all platforms
script = raw"""
export PATH="${bindir}:${PATH}"

cd $WORKSPACE/srcdir/gumbo-parser/
./autogen.sh
./configure --prefix=${prefix} --build=${MACHTYPE} --host=${target}
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms(; experimental=true)

# The products that we will ensure are always built
products = [
    LibraryProduct("libgumbo", :libgumbo)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    BuildDependency(PackageSpec(name="autoconf_jll", version=v"2.72")),
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6")
