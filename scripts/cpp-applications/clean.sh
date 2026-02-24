#!/bin/bash
# Script to remove all build artifacts from the 1000-genome project

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "Cleaning build artifacts from: $SCRIPT_DIR"

# Remove CMake generated files
echo "Removing CMake files..."
rm -rf CMakeCache.txt
rm -rf CMakeFiles/
rm -rf cmake_install.cmake
rm -f Makefile

# Remove compiled binaries
echo "Removing compiled binaries..."
rm -f download
rm -f frequency
rm -f individuals
rm -f individuals_merge
rm -f mutation_overlap
rm -f sifting

# Remove any object files or other intermediate build files
echo "Removing object files and other build artifacts..."
rm -f *.o
rm -f *.a
rm -f *.so

echo "✓ Clean complete! All build artifacts removed."
echo ""
echo "To rebuild the project, run:"
echo "  ./build.sh"
