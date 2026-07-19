#!/usr/bin/env bash
set -Eeuo pipefail

cd /pkgs
cd llvm-project-*

mkdir -p build
cd build

cmake -G Ninja ../llvm \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DLLVM_BUILD_TOOLS=ON \
    -DLLVM_TARGETS_TO_BUILD="X86" \
    -DLLVM_INCLUDE_TESTS=OFF \
    -DLLVM_BUILD_LLVM_DYLIB=ON \
    -DLLVM_LINK_LLVM_DYLIB=ON \
    -DLLVM_INCLUDE_BENCHMARKS=OFF \
    -DLLVM_INCLUDE_EXAMPLES=OFF \
    -DLLVM_BUILD_EXAMPLES=OFF \

ninja -j"$(nproc)"

ninja install

ldconfig