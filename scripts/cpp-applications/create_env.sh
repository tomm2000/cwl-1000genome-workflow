#!/bin/bash
# Script to install dependencies for 1000-genome-cpp

# Don't use set -e if sourcing, or it might close your terminal on error
# We use a confusing 'return' vs 'exit' check to support both running and sourcing
(return 0 2>/dev/null) || set -e

# 1. Locate Spack automatically if not set (more robust than hardcoding $HOME)
if [ -z "$SPACK_ROOT" ]; then
    # Try to find spack in path first
    if command -v spack >/dev/null; then
        SPACK_BIN=$(command -v spack)
        # Strip /bin/spack to get root
        SPACK_ROOT=$(dirname $(dirname "$SPACK_BIN"))
    else
        SPACK_ROOT="$HOME/spack"
    fi
fi

if [ ! -d "$SPACK_ROOT" ]; then
    echo "Error: Spack not found at $SPACK_ROOT"
    return 1 2>/dev/null || exit 1
fi

# 2. Source the shell integration (CRITICAL)
source "$SPACK_ROOT/share/spack/setup-env.sh"

# 3. Create environment idempotently
# We use '|| true' to ignore the error if it exists, clearer than grep
echo "Ensuring environment '1000-genome-cpp' exists..."
spack env create 1000-genome-cpp 2>/dev/null || echo "Environment already exists."

# 4. Activate
spack env activate 1000-genome-cpp

# 5. Add/Install packages (using version ranges for better compatibility)
spack add cmake@3.27:
spack add boost@1.82:+iostreams+program_options
spack add curl@8:
spack add libarchive@3.7:

# 6. Concretize and Install
echo "Concretizing environment..."
spack concretize -f

echo "Installing dependencies..."
echo "This may take a while if packages need to be built from source..."
spack install

echo "Successfully set up dependencies for 1000-genome-cpp!"