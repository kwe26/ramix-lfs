#!/usr/bin/env bash
set -Eeuo pipefail

cd /pkgs
cd libinput-*

meson setup build \
    --prefix=/usr \
    --buildtype=release \
    -Ddocumentation=false \
    -Ddebug-gui=false \
    -Dlibwacom=false \
    -Ddocumentation=false \
    -Dtests=false

meson compile -C build -j"$(nproc)"

meson install -C build

ldconfig