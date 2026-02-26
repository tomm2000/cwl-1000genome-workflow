#!/bin/bash
#SBATCH --job-name=build-1000genome
#SBATCH --partition=broadwell
#SBATCH --nodelist=broadwell-055
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err

# Usage: sbatch build_sbatch.sh [BUILD_DIR]
#   BUILD_DIR defaults to "build"

BUILD_DIR="${1:-build}"

# Setup Spack environment
if [ -z "$SPACK_ROOT" ]; then
    SPACK_ROOT="$HOME/spack"
fi

# Always source setup-env.sh to load shell functions (needed for spack env activate)
echo "Loading Spack environment from $SPACK_ROOT..."
source "$SPACK_ROOT/share/spack/setup-env.sh"

# Activate the Spack environment
echo "Activating Spack environment '1000-genome-cpp'..."
spack env activate 1000-genome-cpp
echo "CMake version: $(cmake --version | head -1)"

# Build
echo "Configuring project (build dir: $BUILD_DIR)..."
cmake -DCMAKE_BUILD_TYPE=Release -B "$BUILD_DIR" .

echo "Building project..."
cmake --build "$BUILD_DIR" --parallel 8

# Mark produced binaries as executable
echo "Setting executable permissions for binaries..."
chmod +x "$BUILD_DIR/download"
chmod +x "$BUILD_DIR/frequency"
chmod +x "$BUILD_DIR/individuals"
chmod +x "$BUILD_DIR/individuals_merge"
chmod +x "$BUILD_DIR/mutation_overlap"
chmod +x "$BUILD_DIR/sifting"

echo "Build complete."
