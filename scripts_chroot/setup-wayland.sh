#!/usr/bin/env bash
set -e

cd /pkgs
cd wayland-1*

mkdir -pv build
cd build

meson setup .. \
    --prefix=/usr \
    --buildtype=release \
    -Ddocumentation=false \
    -Dtests=false

ninja

ninja install

ldconfig