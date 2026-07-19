#!/usr/bin/env bash
set -Eeuo pipefail

cd /pkgs
cd libxkbcommon-*

meson setup build \
    --prefix=/usr \
    --buildtype=release \
    -Denable-docs=false \
    -Denable-x11=false

meson compile -C build -j"$(nproc)"

meson install -C build

ldconfig