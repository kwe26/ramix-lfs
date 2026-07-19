#!/usr/bin/env bash
set -e

cd /pkgs
cd libxml2-*

mkdir -p build
cd build

meson setup .. \
    --prefix=/usr \
    --buildtype=release \
    --default-library=shared \
    -Dpython=disabled 

ninja -j"$(nproc)"

ninja install

ldconfig