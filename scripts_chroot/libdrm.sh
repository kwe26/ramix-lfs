#!/usr/bin/env bash
set -Eeuo pipefail

cd /pkgs
cd libdrm-*

meson setup build \
    --prefix=/usr \
    --buildtype=release \
    -Dudev=true \
    -Dtests=false \
    -Dvalgrind=disabled

meson compile -C build -j"$(nproc)"

meson install -C build

ldconfig