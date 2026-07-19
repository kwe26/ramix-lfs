#!/usr/bin/env bash
set -Eeuo pipefail

cd /pkgs
cd libevdev-*

meson setup build \
    --prefix=/usr \
    --buildtype=release \
    -Dtests=disabled \
    -Ddocumentation=disabled
    
meson compile -C build -j"$(nproc)"

meson install -C build

ldconfig