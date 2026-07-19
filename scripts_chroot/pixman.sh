#!/usr/bin/env bash
set -Eeuo pipefail

cd /pkgs
cd pixman-*

meson setup build \
    --prefix=/usr \
    --buildtype=release

meson compile -C build -j"$(nproc)"

meson install -C build

ldconfig