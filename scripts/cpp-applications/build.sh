#!/bin/bash
# Build script for 1000-genome C++ applications

# Setup Spack environment if not already loaded
if [ -z "$SPACK_ROOT" ]; then
    SPACK_ROOT="$HOME/spack"
fi

if command -v spack &> /dev/null; then
    echo "Spack already loaded"
else
    echo "Loading Spack environment..."
    source "$SPACK_ROOT/share/spack/setup-env.sh"
fi

# Activate the Spack environment
if [ -z "$SPACK_ENV" ]; then
    echo "Activating Spack environment '1000-genome-cpp'..."
    spack env activate 1000-genome-cpp
else
    echo "Spack environment already active: $SPACK_ENV"
fi

# Build
echo "Configuring project..."
cmake -DCMAKE_BUILD_TYPE=Release .

echo "Building project..."
cmake --build . --parallel 8