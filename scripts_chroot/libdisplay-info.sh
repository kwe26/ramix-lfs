#!/usr/bin/env bash
set -Eeuo pipefail

cd /pkgs
cd libdisplay-info-*

meson setup build \
    --prefix=/usr \
    --buildtype=release 

meson compile -C build -j"$(nproc)"

meson install -C build

ldconfig